{*
* 2007-2017 PrestaShop
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
*  @copyright  2007-2017 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
<div id="_desktop_contact_link">
    <div class="header__contact dropdown js-dropdown">
        <span class="expand-more font-phone-call hidden-lg-up" data-toggle="dropdown" aria-expanded="false"></span>
        <div class="dropdown-menu header__contact__list js-header__contact__list toogle_content">
            <div>
                {if $contact_infos.phone}
                <a class="header__contact__item shop-phone" href="tel:{$contact_infos.phone}" title="{l s='Contact us' d='Shop.Theme.Global'}">
                    <i class="font-phone-call"></i>
                    {$contact_infos.phone}
                </a>
                {/if}
                {*
                <a class="header__contact__item" href="{$urls.pages.contact}">
                    <i class="material-icons">&#xE3C9;</i>
                    {l s='Contact us' d='Shop.Theme.Global'}
                </a>
               *}
            </div>
        </div>
    </div>
</div>
