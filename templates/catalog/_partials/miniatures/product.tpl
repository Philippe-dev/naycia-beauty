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
{block name='product_miniature_item'}
  <article class="product-miniature js-product-miniature" data-id-product="{$product.id_product}" data-id-product-attribute="{$product.id_product_attribute}" itemscope itemtype="http://schema.org/Product">
    <div class="thumbnail-container">
      <div class="thumbnail-wrapper">
        {block name='product_thumbnail'}
          <a href="{$product.canonical_url}" class="thumbnail product-thumbnail">
            
            {if $product.cover}
            <img
              class="thumbnail-img"
              src="{$product.cover.bySize.home_default.url}"
              alt="{$product.cover.legend}"
              data-full-size-image-url="{$product.cover.large.url}"
              itemprop="image"
            >
            {else}
            <img
                class="thumbnail-img"
                src="{$urls.no_picture_image.bySize.home_default.url}"
              >
            {/if}
          </a>
        {/block}
          {block name='product_flags'}
          <ul class="product-flags">
            {if $product.show_price}
                {if $product.has_discount}
                  {if $product.discount_type === 'percentage'}
                    <li class="discount-percentage">{$product.discount_percentage}</li>
                  {/if}
                {/if}
            {/if}
            {foreach from=$product.flags item=flag}
              <li class="{$flag.type}">{$flag.label}</li>
            {/foreach}
          </ul>
          {/block}
          {block name='product_variants'}
          {if $product.main_variants}
            {include file='catalog/_partials/variant-links.tpl' variants=$product.main_variants}
          {/if}
          {/block}
      </div>
      <div class="right-block">
          <div class="product-desc">
            {block name='product_reviews'}
              {hook h='displayProductListReviews' product=$product}
            {/block}
            {block name='product_name'}
              <h3 class="h3 product-title" itemprop="name"><a href="{$product.canonical_url}">{$product.name|truncate:60:'...'}</a></h3>
            {/block}
            {block name='product_description'}
              {if $product.description}
              <p class="product_desc" itemprop="description">{$product.description|strip_tags:'UTF-8'|truncate:150:'...'}</p>
              {/if}
            {/block}
            {if Manufacturer::getnamebyid($product.id_manufacturer)}
            <meta itemprop="brand" content="{Manufacturer::getnamebyid($product.id_manufacturer)}"/>
            {/if}
            {if $product.reference}
            <meta itemprop="sku" content="{$product.reference}" />
            {/if}
            {if $product.ean13}
              <meta itemprop="gtin13" content="{$product.ean13}" />
            {/if}
            {block name='product_price_and_shipping'}
              {if $product.show_price}
                <div class="product-price-and-shipping" itemprop="offers" itemtype="http://schema.org/Offer" itemscope>
                  <link itemprop="url" href="{$product.canonical_url}" />
                  <meta itemprop="availability" content="{if $product.available_for_order == 1}https://schema.org/InStock{else}https://schema.org/OutOfStock{/if}" />
                  <meta itemprop="priceCurrency" content="{$currency.iso_code}" />
                  {*From label*}
                        {hook h='displayProductPriceBlock' product=$product type="before_price"}
                  {*End label*}
                  <span itemprop="price" content="{$product.price_amount}" class="price">{$product.price}</span>
                  {if $product.has_discount}
                    {hook h='displayProductPriceBlock' product=$product type="old_price"}

                    <span class="regular-price">{$product.regular_price}</span>
                  {/if}


                  {hook h='displayProductPriceBlock' product=$product type='unit_price'}

                {hook h='displayProductPriceBlock' product=$product type='weight'}
                {*Start adding tax and delivery labels*}
                {if $configuration.taxes_enabled && $configuration.display_taxes_label}
                  {$product.labels.tax_long}
                {/if}
                {hook h='displayProductPriceBlock' product=$product type="price"}
                {if $product.delivery_information}
                    {$product.delivery_information}
                {/if}
                {*End adding tax and delivery labels*}
              </div>
            {/if}
            {/block}
        </div>
        <div class="highlighted-informations{if !$product.main_variants} no-variants{/if}">
          {include file='catalog/_partials/custom/add-to-cart-product-list.tpl' product=$product name_module='product-list'}
          {hook h='displayProductListFunctionalButtons' product=$product}
          {block name='quick_view'}
            <a class="quick-view" href="#" data-link-action="quickview" title="{l s='Quick view' d='Shop.Theme.Actions'}">
              <i class="font-eye-1"></i><span>{l s='Quick view' d='Shop.Theme.Actions'}</span>
            </a>
          {/block}
          {block name='more_info'}
              <a href="{$product.canonical_url}" class="link-view" title="{l s='More info' d='Shop.Nayciabeauty'}">
                  <i class="font-info-circled"></i><span>{l s='More info' d='Shop.Nayciabeauty'}</span>
              </a>
          {/block}
        </div>
      </div>
     </div>
  </article>
{/block}

