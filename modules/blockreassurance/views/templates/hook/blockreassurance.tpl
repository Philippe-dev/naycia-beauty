{*
* 2007-2015 PrestaShop
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
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2015 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
{if $elements}
  <div id="block-reassurance">
    <ul>
      {foreach from=$elements item=element}
        {if $element.text == "Paiement sécurisé"}{$url="/fr/content/5-paiement-securise"}{/if}
	    {if $element.text == "Livraisons rapides"}{$url="/fr/content/1-livraison"}{/if}
        {if $element.text == "Politique retours"}{$url="/fr/content/3-conditions-utilisation"}{/if}

        {if $element.text == "Secure checkout"}{$url="/en/content/5-secure-payment"}{/if}
        {if $element.text == "Fast deliveries"}{$url="/en/content/1-shipping"}{/if}
        {if $element.text == "Returns Policy"}{$url="/en/content/3-terms-of-use"}{/if}

        <li><a href="{$url}"><img src="{$element.image}" alt="{$element.text|escape:'quotes'}" /> <span>{$element.text}</span></a></li>
      {/foreach}
    </ul>
  </div>
{/if}

