<div id="blockcart-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          {*<span aria-hidden="true">&times;</span>*}
        </button>
      <div class="modal-body">
        <div class="row">
          <div class="col-lg-6 divide-right">
               {*<h4><i class="material-icons">&#xE876;</i>{l s='Product successfully added to your shopping cart' d='Shop.Theme.Checkout'}</h4>*}
                {*<img class="product-image" src="{$product.cover.large.url}" alt="{$product.cover.legend}" title="{$product.cover.legend}" itemprop="image">*}
                <div class="product-image" style="background-image: url({$product.cover.bySize.large_default.url});"></div>
          </div>
          <div class="col-lg-6 cart-content">
                <p class="h6 product-name">{$product.name}</p>
                {if $cart.products_count > 1}
                  <p class="cart-products-count">{l s='There are %products_count% items in your cart.' sprintf=['%products_count%' => $cart.products_count] d='Shop.Theme.Checkout'}</p>
                {else}
                  <p class="cart-products-count">{l s='There is %product_count% item in your cart.' sprintf=['%product_count%' =>$cart.products_count] d='Shop.Theme.Checkout'}</p>
                {/if}
                <p><strong>{l s='Price' d='Shop.Theme.Catalog'}</strong><span>{$product.price}</span></p>
                <p><strong>{l s='Quantity' d='Shop.Theme.Checkout'}</strong><span>{$product.cart_quantity}</span></p>
                {hook h='displayProductPriceBlock' product=$product type="unit_price"}
                {foreach from=$product.attributes item="property_value" key="property"}
                  <p><strong>{$property}</strong> <span>{$property_value}</span></p>
                {/foreach}
                <p><strong>{l s='Total products:' d='Shop.Theme.Checkout'}</strong><span>{$cart.subtotals.products.value}</span></p>
                <p><strong>{l s='Total shipping:' d='Shop.Theme.Checkout'}</strong><span>{$cart.subtotals.shipping.value}{hook h='displayCheckoutSubtotalDetails' subtotal=$cart.subtotals.shipping}</span></p>
              {if $cart.subtotals.tax}
                <p><strong>{$cart.subtotals.tax.label}</strong><span>{$cart.subtotals.tax.value}</span></p>
              {/if}
              <p><strong>{l s='Total' d='Shop.Theme.Checkout'}</strong><span>{$cart.totals.total.value} {$cart.labels.tax_short}</span></p>
              <div class="cart-content-btn">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">{l s='Continue shopping' d='Shop.Theme.Actions'}</button>
                <a href="{$cart_url}" class="btn btn-primary">{*<i class="material-icons">&#xE876;</i>*}{l s='Proceed to checkout' d='Shop.Theme.Actions'}</a>
              </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
