<?php
/**
 * 2007-2019 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2019 PrestaShop SA
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *  International Registered Trademark & Property of PrestaShop SA
 */

/**
 * Class AdminColissimoColishipController
 *
 * Processes:
 *  - downloadFmt
 *  - exportCsv
 *
 */
class AdminColissimoColishipController extends ModuleAdminController
{
    /** @var Colissimo $module */
    public $module;

    /** @var string $header */
    private $header;

    //@formatter:off
    /** @var array MIME types authorized for CSV files */
    private $authorizedFileTypes = array('application/vnd.ms-excel', 'text/csv', 'application/octet-stream', 'text/plain', 'text/comma-separated-values');
    //@formatter:on

    /**
     * AdminColissimoAffranchissementController constructor.
     * @throws PrestaShopException
     */
    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
        $this->module->logger->setChannel('Coliship');
    }

    /**
     * @throws Exception
     * @throws SmartyException
     */
    public function initProcess()
    {
        $this->header = $this->module->setColissimoControllerHeader();
        parent::initProcess();
    }

    /**
     * @param string $file
     * @return array|bool
     */
    public function parseCsv($file)
    {
        if (($fd = @fopen($file, 'r')) == false) {
            return false;
        }
        $csv = array();
        $headers = fgetcsv($fd, 0, ';');
        while (($data = fgetcsv($fd, 0, ';')) !== false) {
            $csv[] = array_combine($headers, $data);
        }

        return $csv;
    }

    /**
     * @return bool|ObjectModel|void
     */
    public function postProcess()
    {
        parent::postProcess();
        if (Tools::isSubmit('submitColishipImport')) {
            try {
                $file = $this->postProcessColishipUpload();
            } catch (Exception $e) {
                $this->module->logger->error($e->getMessage());
                $this->errors[] = $e->getMessage();

                return;
            }
            $data = $this->parseCsv($file);
            $this->importLabels($data);
        }
    }

    /**
     * @throws Exception
     */
    public function initContent()
    {
        $modePS = Configuration::get('COLISSIMO_GENERATE_LABEL_PRESTASHOP');
        $accessImportShippingNumbers = Tools::getValue('importCsv');
        if (!$accessImportShippingNumbers && $modePS) {
            //@formatter:off
            $this->errors[] = $this->module->l('Colissimo postage mode is set to "PrestaShop". If you want to import & export orders using Coliship, change this setting in Colissimo module.', 'AdminColissimoColishipController');
            //@formatter:on
            return;
        }
        if (!ColissimoTools::isValidHsCode(Configuration::get('COLISSIMO_DEFAULT_HS_CODE'))) {
            //@formatter:off
            $this->warnings[] = $this->module->l('You did not fill a valid HS Code in the Colissimo module configuration. You may encounter errors when importing orders in Coliship.', 'AdminColissimoColishipController');
            //@formatter:on
        }
        $idCurrencyEUR = Currency::getIdByIsoCode('EUR');
        if ((int) !$idCurrencyEUR) {
            //@formatter:off
            $this->warnings[] = $this->module->l('The currency EUR is not installed. This will cause wrong product values in CN23 documents.', 'AdminColissimoColishipController');
            //@formatter:on
        }
        $tmpDirectory = sys_get_temp_dir();
        if ($tmpDirectory && Tools::substr($tmpDirectory, -1) != DIRECTORY_SEPARATOR) {
            $tmpDirectory .= DIRECTORY_SEPARATOR;
        }
        $tmpDirectory = realpath($tmpDirectory);
        if (!is_writable($tmpDirectory)) {
            //@formatter:off
            $this->errors[] = sprintf($this->module->l('Please grant write permissions to the temporary directory of your server (%s).', 'AdminColissimoColishipController'), $tmpDirectory);
            //@formatter:on
        }
        $helperUpload = new HelperUploader('coliship_import');
        $helperUpload->setId(null);
        $helperUpload->setName('coliship_import');
        $helperUpload->setUrl(null);
        $helperUpload->setMultiple(false);
        $helperUpload->setUseAjax(false);
        $helperUpload->setMaxFiles(null);
        $helperUpload->setFiles(
            array(
                0 => array(
                    'type'         => HelperUploader::TYPE_FILE,
                    'size'         => null,
                    'delete_url'   => null,
                    'download_url' => null,
                ),
            )
        );
        $this->context->smarty->assign(
            array(
                'helper_upload' => $helperUpload->render(),
                'coliship_url'  => Colissimo::COLISHIP_URL,
                'admin_url'     => $this->context->link->getAdminLink('AdminColissimoColiship'),
            )
        );
        if ($accessImportShippingNumbers) {
            $this->context->smarty->assign(
                array(
                    'import_csv' => 1,
                    'csv_path'   => _MODULE_DIR_.'colissimo/shippingNumbers.csv',
                    'img_path'   => $this->module->getPathUri().'views/img/',
                )
            );
        }
        $this->content = $this->createTemplate('coliship-form.tpl')
                              ->fetch();
        $this->content = $this->header.$this->content;
        parent::initContent();
    }

    /**
     * @return string
     * @throws Exception
     */
    public function postProcessColishipUpload()
    {
        if (!isset($_FILES['coliship_import']['error']) || is_array($_FILES['coliship_import']['error'])) {
            throw new Exception($this->module->l('Invalid parameters.', 'AdminColissimoColishipController'));
        }
        switch ($_FILES['coliship_import']['error']) {
            case UPLOAD_ERR_OK:
                break;
            case UPLOAD_ERR_NO_FILE:
                throw new Exception($this->module->l('No files sent.', 'AdminColissimoColishipController'));
            case UPLOAD_ERR_INI_SIZE:
            case UPLOAD_ERR_FORM_SIZE:
                throw new Exception($this->module->l('Exceeded filesize limit.', 'AdminColissimoColishipController'));
            default:
                throw new Exception($this->module->l('Unknown errors.', 'AdminColissimoColishipController'));
        }
        $fileType = $_FILES['coliship_import']['type'];
        //@formatter:off
        if (!in_array($fileType, $this->authorizedFileTypes)) {
            $this->module->logger->warning(sprintf('MIME type uploaded: %s', $fileType));
            throw new Exception($this->module->l('You must submit CSV files only.', 'AdminColissimoColishipController'));
        }
        //@formatter:on
        $file = _PS_MODULE_DIR_.$this->module->name.'/documents/coliship/'.date('YmdHis').'.csv';
        if (!move_uploaded_file($_FILES['coliship_import']['tmp_name'], $file)) {
            throw new Exception($this->module->l('Cannot upload .csv file.', 'AdminColissimoColishipController'));
        }

        return $file;
    }

    /**
     * @param array $data
     */
    public function importLabels($data)
    {
        $result = array_fill_keys(array('success', 'error'), array());
        foreach ($data as $i => $label) {
            $orders = Order::getByReference($label['ReferenceExpedition']);
            if (!$orders->count()) {
                $this->module->logger->error('Order ref. '.$label['ReferenceExpedition'].' not found.');
                $result['error'][] = sprintf(
                    $this->module->l('Line %d - Order not found', 'AdminColissimoColishipController'),
                    $i + 1
                );
                continue;
            }
            if (ColissimoLabel::getLabelIdByShippingNumber($label['NumeroColis'])) {
                $this->module->logger->error('Label '.$label['NumeroColis'].' already exists.');
                $result['error'][] = sprintf(
                    $this->module->l('Line %d - Label already exists.', 'AdminColissimoColishipController'),
                    $i + 1
                );
                continue;
            }
            try {
                /** @var Order $order */
                $order = $orders->getFirst();
                $colissimoLabel = new ColissimoLabel();
                $colissimoLabel->id_colissimo_order = (int) ColissimoOrder::getIdByOrderId($order->id);
                $colissimoLabel->id_colissimo_deposit_slip = 0;
                $colissimoLabel->shipping_number = pSQL($label['NumeroColis']);
                $colissimoLabel->label_format = 'pdf';
                $colissimoLabel->return_label = 0;
                $colissimoLabel->cn23 = 0;
                $colissimoLabel->coliship = 1;
                $colissimoLabel->migration = 0;
                $colissimoLabel->insurance = null;
                $colissimoLabel->file_deleted = 0;
                $colissimoLabel->save(true);
                if (Configuration::get('COLISSIMO_USE_SHIPPING_IN_PROGRESS')) {
                    $idShippingInProgressOS = Configuration::get('COLISSIMO_OS_SHIPPING_IN_PROGRESS');
                    $shippingInProgressOS = new OrderState((int) $idShippingInProgressOS);
                    if (Validate::isLoadedObject($shippingInProgressOS)) {
                        if (!$order->getHistory($this->context->language->id, (int) $idShippingInProgressOS)) {
                            $history = new OrderHistory();
                            $history->id_order = (int) $order->id;
                            $history->changeIdOrderState($idShippingInProgressOS, (int) $order->id);
                            try {
                                $history->add();
                            } catch (Exception $e) {
                                $this->module->logger->error(sprintf('Cannot change status of order #%d', $order->id));
                            }
                        }
                    } else {
                        $this->module->logger->error('Shipping in Progress order state is not valid');
                    }
                }
                $orderCarrier = ColissimoOrderCarrier::getByIdOrder($order->id);
                if (Validate::isLoadedObject($orderCarrier) && !$orderCarrier->tracking_number) {
                    $orderCarrier->tracking_number = pSQL($colissimoLabel->shipping_number);
                    $orderCarrier->save();
                    $hash = md5($order->reference.$order->secure_key);
                    $link = $this->context->link->getModuleLink(
                        'colissimo',
                        'tracking',
                        array('order_reference' => $order->reference, 'hash' => $hash)
                    );
                    $isoLangOrder = Language::getIsoById($order->id_lang);
                    if (isset($this->module->PNAMailObject[$isoLangOrder])) {
                        $object = $this->module->PNAMailObject[$isoLangOrder];
                    } else {
                        $object = $this->module->PNAMailObject['en'];
                    }
                    ColissimoTools::sendHandlingShipmentMail(
                        $order,
                        sprintf($object, $order->reference),
                        $link
                    );
                    $this->module->logger->info('Send tracking mail for shipment '.$colissimoLabel->shipping_number);
                }
            } catch (Exception $e) {
                $this->module->logger->error('Error thrown: '.$e->getMessage());
                $result['error'][] = sprintf(
                    $this->module->l('Line %d - %s', 'AdminColissimoColishipController'),
                    $i + 1,
                    $e->getMessage()
                );
                continue;
            }
            $result['success'][] = $colissimoLabel->id;
        }
        if (!empty($result['error'])) {
            $this->errors = $result['error'];
        }
        if (!empty($result['success'])) {
            $this->confirmations = sprintf(
                $this->module->l('%d label(s) have been imported successfully', 'AdminColissimoColishipController'),
                count($result['success'])
            );
        }
    }

    /**
     * @return bool
     */
    public function processDownloadFmt()
    {
        $file = $this->module->getLocalPath().'PrestaShop.FMT';
        if (file_exists($file)) {
            header('Content-Description: File Transfer');
            header('Content-Type: application/octet-stream');
            header('Content-Disposition: attachment; filename="'.basename($file).'"');
            header('Expires: 0');
            header('Cache-Control: must-revalidate');
            header('Pragma: public');
            readfile($file);
            exit;
        } else {
            return false;
        }
    }

    /**
     * @throws PrestaShopDatabaseException
     * @throws Exception
     */
    public function processExportCsv()
    {
        $selectedStates = array_keys(json_decode(Configuration::get('COLISSIMO_GENERATE_LABEL_STATUSES'), true));
        $dbQuery = new DbQuery();
        //@formatter:off
        $dbQuery->select('co.*')
                ->from('colissimo_order', 'co')
                ->leftJoin('orders', 'o', 'o.`id_order` = co.`id_order`')
                ->leftJoin('colissimo_label', 'cola', 'cola.`id_colissimo_order` = co.`id_colissimo_order`');
        //@formatter:on
        if (!empty($selectedStates)) {
            $dbQuery->where('o.`current_state` IN ('.implode(',', array_map('intval', $selectedStates)).')');
        }
        $dbQuery->where('cola.id_colissimo_label IS NULL'.Shop::addSqlRestriction(false, 'o'));
        $dbQuery->orderBy('o.date_add DESC');
        $results = Db::getInstance(_PS_USE_SQL_SLAVE_)
                     ->executeS($dbQuery);

        $insuredAmountEUR = 0;
        $senderAddr = new ColissimoMerchantAddress('sender');
        $lines = array();
        $exportDetails = array(
            'nb_result'         => count($results),
            'restricted_states' => $selectedStates,
        );
        $this->module->logger->info('Export CSV', $exportDetails);
        foreach ($results as $result) {
            $order = new Order((int) $result['id_order']);
            $colissimoService = new ColissimoService((int) $result['id_colissimo_service']);
            $customerAddr = new Address((int) $order->id_address_delivery);
            if ($colissimoService->type == ColissimoService::TYPE_RELAIS) {
                $pickupAddr = new ColissimoPickupPoint((int) $result['id_colissimo_pickup_point']);
                $ftd = '';
            } else {
                $pickupAddr = new ColissimoPickupPoint();
                $isoCustomerAddress = Country::getIsoById((int) $customerAddr->id_country);
                $isoOutreMerFtd = ColissimoTools::$isoOutreMer;
                if (($key = array_search('YT', $isoOutreMerFtd)) !== false) {
                    unset($isoOutreMerFtd[$key]);
                }
                if (($key = array_search('PM', $isoOutreMerFtd)) !== false) {
                    unset($isoOutreMerFtd[$key]);
                }
                $ftd = in_array($isoCustomerAddress, $isoOutreMerFtd) ? 'O' : '';
                if ($colissimoService->isInsurable($isoCustomerAddress)) {
                    if (Configuration::get('COLISSIMO_INSURE_SHIPMENTS')) {
                        $insuredAmount = $order->total_products;
                        $insuredAmountEUR = ColissimoTools::convertInEUR(
                            $insuredAmount,
                            new Currency($order->id_currency)
                        );
                    }
                }
            }
            $customer = new Customer((int) $order->id_customer);

            $lineExp = array(
                'exp_code'         => 'EXP',
                'order_reference'  => $order->reference,
                'exp_company'      => $senderAddr->companyName,
                'exp_lastname'     => $senderAddr->lastName,
                'exp_firstname'    => $senderAddr->firstName,
                'exp_address1'     => $senderAddr->line2,
                'exp_address2'     => $senderAddr->line3,
                'exp_address3'     => $senderAddr->line0,
                'exp_address4'     => $senderAddr->line1,
                'exp_zipcode'      => $senderAddr->zipCode,
                'exp_city'         => $senderAddr->city,
                'exp_iso_country'  => $senderAddr->countryCode,
                'exp_email'        => $senderAddr->email,
                'exp_phone'        => $senderAddr->phoneNumber,
                'dest_company'     => $customerAddr->company,
                'dest_lastname'    => $customerAddr->lastname,
                'dest_firstname'   => $customerAddr->firstname,
                'dest_address1'    => $customerAddr->address1,
                'dest_address2'    => $customerAddr->address2,
                'dest_address3'    => '',
                'dest_address4'    => $customerAddr->address2,
                'dest_zipcode'     => $customerAddr->postcode,
                'dest_city'        => str_replace("-"," ",$customerAddr->city),
                'dest_iso_country' => Country::getIsoById($customerAddr->id_country),
                'dest_mobile'      => $customerAddr->phone_mobile,
                'dest_phone'       => $customerAddr->phone,
                'dest_email'       => $customer->email,
                'pr_code'          => $pickupAddr->colissimo_id,
                'product_code'     => $colissimoService->product_code,
                'ftd'              => $ftd,
                'iso_lang'         => Language::getIsoById($customer->id_lang),
                'signature'        => $colissimoService->is_signature ? 'O' : 'N',
                'weight'           => ColissimoTools::getOrderTotalWeightInKg($order) * 1000,
                'nature'           => ColissimoLabelGenerator::COLISHIP_CATEGORY_COMMERCIAL,
                'insurance'        => $insuredAmountEUR,
                'cpass_id'         => ColissimoTools::getCPassIdByOrderId($order->id),
            );
            $lines[] = $lineExp;
            $isoCustomerAddress = Country::getIsoById((int) $customerAddr->id_country);
            $merchantAddress = new ColissimoMerchantAddress('sender');
            if (ColissimoTools::needCN23($merchantAddress->countryCode, $isoCustomerAddress, $customerAddr->postcode)) {
                $currency = new Currency((int) $order->id_currency);
                $products = $order->getProducts();
                foreach ($products as $product) {
                    $productPriceEUR = ColissimoTools::convertInEUR(
                        $product['unit_price_tax_excl'],
                        new Currency($order->id_currency)
                    );
                    $productWeight = (float) $product['product_weight'] ? ColissimoTools::weightInKG(
                        $product['product_weight']
                    ) : 0.05;
                    $lineCN23 = array(
                        'cn_code'           => 'CN2',
                        'cn_print'          => 'O',
                        'cn_article_name'   => $product['product_name'],
                        'cn_article_weight' => $productWeight * 1000,
                        'cn_article_qty'    => $product['product_quantity'],
                        'cn_article_value'  => (float) $productPriceEUR,
                        'cn_article_origin' => 'FR',
                        'cn_currency'       => $currency->iso_code,
                        'cn_article_ref'    => $product['product_reference'],
                        'cn_hs_code'        => Configuration::get('COLISSIMO_DEFAULT_HS_CODE'),
                    );
                    $lines[] = $lineCN23;
                }
            }
        }
        try {
            ColissimoTools::downloadColishipExport($lines);
        } catch (Exception $e) {
            $this->module->logger->error($e->getMessage());
            //@formatter:off
            $this->errors[] = $this->module->l('Cannot export CSV file. Please check the module logs.', 'AdminColissimoColishipController');
            //@formatter:on
        }
    }
}
