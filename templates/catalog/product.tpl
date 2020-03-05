{**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
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
 * @copyright 2007-2017 PrestaShop SA
 * @license   http://opensource.org/licenses/osl-3.0.php Open Software License (OSL 3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
{extends file=$layout}

{block name='head_seo' prepend}
  <link rel="canonical" href="{$product.canonical_url}">
{/block}

{block name='head' append}
  <meta property="og:type" content="product">
  <meta property="og:url" content="{$urls.current_url}">
  <meta property="og:title" content="{$page.meta.title}">
  <meta property="og:site_name" content="{$shop.name}">
  <meta property="og:description" content="{$page.meta.description}">
  <meta property="og:image" content="{$product.cover.large.url}">
  {if $product.show_price}
    <meta property="product:pretax_price:amount" content="{$product.price_tax_exc}">
    <meta property="product:pretax_price:currency" content="{$currency.iso_code}">
    <meta property="product:price:amount" content="{$product.price_amount}">
    <meta property="product:price:currency" content="{$currency.iso_code}">
  {/if}
  {if isset($product.weight) && ($product.weight != 0)}
  <meta property="product:weight:value" content="{$product.weight}">
  <meta property="product:weight:units" content="{$product.weight_unit}">
  {/if}
{/block}

{block name='content'}

  <section id="main" itemscope itemtype="https://schema.org/Product">
      
    <div class="row">
      <div class="col-lg-5 l-column p-page">
        {block name='page_content_container'}
          <section class="page-content" id="content">
            {block name='page_content'}
              {block name='product_cover_thumbnails'}
                {include file='catalog/_partials/product-cover-thumbnails.tpl'}
              {/block}
            {/block}
          </section>
        {/block}
        </div>
        <div class="col-lg-7 r-column">
          {block name='page_header_container'}
            {block name='page_header'}
              <h1 class="h1" itemprop="name">{block name='page_title'}{$product.name}{/block}</h1>
            {/block}
          {/block}
          {if Module::isInstalled(productcomments) && Module::isEnabled(productcomments)}
            <div class="js-additional-info-to additional-info-to"></div>
          {/if}
          {block name='product_details_info'}
                {if isset($product_manufacturer->id)}
                  <div class="product-manufacturer">
                    {if isset($manufacturer_image_url)}
                      <a href="{$product_brand_url}">
                        <img src="{$manufacturer_image_url}" class="img manufacturer-logo" />
                      </a>
                    {else}
                      <label class="label">{l s='Brand' d='Shop.Theme.Catalog'}</label>
                      <span>
                        <a href="{$product_brand_url}">{$product_manufacturer->name}</a>
                      </span>
                    {/if}
                    <meta itemprop="brand" content="{$product_manufacturer->name}" />
                  </div>
                {/if}
              {if $product.ean13}
                <meta itemprop="gtin13" content="{$product.ean13}" />
              {/if}
              {block name='product_prices'}
                {include file='catalog/_partials/product-prices.tpl'}
              {/block}
          {/block}
          <div class="product-information">
            {if $product.is_customizable && count($product.customizations.fields)}
              {block name='product_customization'}
                {include file="catalog/_partials/product-customization.tpl" customizations=$product.customizations}
              {/block}
            {/if}
            <div class="product-actions">
              {block name='product_buy'}
                <form action="{$urls.pages.cart}" method="post" id="add-to-cart-or-refresh">
                  <input type="hidden" name="token" value="{$static_token}">
                  <input type="hidden" name="id_product" value="{$product.id}" id="product_page_product_id">
                  <input type="hidden" name="id_customization" value="{$product.id_customization}" id="product_customization_id">

                  {block name='product_variants'}
                    {include file='catalog/_partials/product-variants.tpl'}
                  {/block}

                  {block name='product_pack'}
                    {if $packItems}
                      <section class="product-pack">
                        <h3 class="h4">{l s='This pack contains' d='Shop.Theme.Catalog'}</h3>
                        {foreach from=$packItems item="product_pack"}
                          {block name='product_miniature'}
                            {include file='catalog/_partials/miniatures/pack-product.tpl' product=$product_pack}
                          {/block}
                        {/foreach}
                    </section>
                    {/if}
                  {/block}

                  {block name='product_discounts'}
                    {include file='catalog/_partials/product-discounts.tpl'}
                  {/block}

                  {block name='product_add_to_cart'}
                    {include file='catalog/_partials/product-add-to-cart.tpl'}
                  {/block}

                  {block name='product_additional_info'}
                    {include file='catalog/_partials/product-additional-info.tpl'}
                  {/block}

                  {block name='product_refresh'}
                    <input class="product-refresh ps-hidden-by-js" name="refresh" type="submit" value="{l s='Refresh' d='Shop.Theme.Actions'}">
                  {/block}
                </form>
              {/block}
                            
            </div>

            {block name='hook_display_reassurance'}
              {hook h='displayReassurance'}
            {/block}
          </div>
        </div>
      </div>
    {block name='product_tabs'}
         <div class="more-info">
           <ul class="nav nav-tabs_alternative">
             {if $product.description}
             <li class="nav-item">
               <a class="more-info-tab nav-link" data-toggle="tab" href="#description">
                 {l s='Description' d='Shop.Theme.Catalog'}
               </a>
             </li>
             {/if}
             {if $product.condition || (isset($product.reference_to_display) && $product.reference_to_display neq '') || $product.show_quantities || $product.availability_date || $product.minimal_quantity > 1 || $product.grouped_features || !empty($product.specific_references)}
               <li class="nav-item">
                 <a class="data-sheet-tab nav-link" data-toggle="tab" href="#product-details">
                   {l s='Product Details' d='Shop.Theme.Catalog'}
                 </a>
               </li>
             {/if}
             {if $product.attachments}
             <li class="nav-item">
               <a class="nav-link" data-toggle="tab" href="#attachments">
                 {l s='Attachments' d='Shop.Theme.Catalog'}
               </a>
             </li>
             {/if}
             {foreach from=$product.extraContent item=extra key=extraKey}
             <li class="nav-item">
               <a class="nav-link" data-toggle="tab" href="#extra-{$extraKey}">{$extra.title}</a>
             </li>
             {/foreach}
             {if $accessories}
            <li class="nav-item">
               <a class="nav-link" data-toggle="tab" href="#accessories">{l s='Accessories' d='Shop.Theme.Catalog'}</a>
             </li>
             {/if}
             {if Module::isInstalled(productcomments) && Module::isEnabled(productcomments)}
              <li id="product-comments-list-header" class="nav-item">
                  <a class="nav-link" data-toggle="tab" href="#productcomments">
                    {l s='Comments' d='Modules.Productcomments.Shop'}
                  </a>
              </li>
              {/if}
            {block name='product_tab'}
                {hook h='productTab' product=$product category=$category}
            {/block}
           </ul>
            
           <div class="tab-content" id="tab-content">
           {if $product.description}
            <div class="tab-pane fade in" id="description">
              {block name='product_description'}
                <div class="product-description tab-pane-inner rte">{$product.description nofilter}</div>
              {/block}
            </div>
            {/if}
            {block name='product_details'}
              {include file='catalog/_partials/product-details.tpl'}
            {/block}

            {block name='product_attachments'}
              {if $product.attachments}
               <div class="tab-pane fade in" id="attachments">
                  <section class="product-attachments tab-pane-inner">
                    <h3 class="h5 text-uppercase">{l s='Download' d='Shop.Theme.Actions'}</h3>
                    {foreach from=$product.attachments item=attachment}
                      <div class="attachment">
                        <h4><a href="{url entity='attachment' params=['id_attachment' => $attachment.id_attachment]}">{$attachment.name}</a></h4>
                        <p>{$attachment.description}</p>
                        <a href="{url entity='attachment' params=['id_attachment' => $attachment.id_attachment]}">
                          {l s='Download' d='Shop.Theme.Actions'} ({$attachment.file_size_formatted})
                        </a>
                      </div>
                    {/foreach}
                  </section>
                </div>
              {/if}
            {/block}

            {foreach from=$product.extraContent item=extra key=extraKey}
            <div class="tab-pane fade in {$extra.attr.class}" id="extra-{$extraKey}" {foreach $extra.attr as $key => $val} {$key}="{$val}"{/foreach}>
              <div class="tab-pane-inner">
              {$extra.content nofilter}
              </div>
            </div>
            {/foreach}
            {block name='product_accessories'}
              {if $accessories}
                <div id="accessories" class="tab-pane fade in">
                    <div class="product-accessories">
                      <div class="products grid row js-carousel-products">
                        {foreach from=$accessories item="product_accessory"}
                          {block name='product_miniature'}
                            {include file='catalog/_partials/miniatures/product.tpl' product=$product_accessory}
                          {/block}
                        {/foreach}
                      </div>
                    </div>
                </div>
              {/if}
            {/block}
            {block name='product_tab_content'}
              {hook h='productTabContent' product=$product category=$category}
            {/block}
            {block name='product_footer'}
              {hook h='displayFooterProduct' product=$product category=$category}
            {/block}
         </div>
         </div>
    {/block}

    {block name='product_images_modal'}
      {include file='catalog/_partials/product-images-modal.tpl'}
    {/block}

    {block name='page_footer_container'}
      <footer class="page-footer">
        {block name='page_footer'}
          <!-- Footer content -->
        {/block}
      </footer>
    {/block}
  </section>

{/block}
