<div id="block_mykitty" class="footer-block links col-lg-3">
  <p class="h3 text-uppercase hidden-md-down">{$mykitty_title_{$language.id}}</p>
  <div class="title clearfix hidden-lg-up" data-target="#footer_mykitty" data-toggle="collapse">
    <span class="h3">{$mykitty_title_{$language.id}}</span>
    <span class="pull-xs-right">
      <span class="navbar-toggler collapse-icons">
        <i class="material-icons add">&#xE313;</i>
        <i class="material-icons remove">&#xE316;</i>
      </span>
    </span>
  </div>
  <div class="collapse" id="footer_mykitty">
     {if $mykitty_href_{$language.id} != ""}<a href="{$mykitty_href_{$language.id}}">{/if}
     <div id="mykitty" class="block">
      <div id="logo"></div>
      <div id="somme">{$mykitty_total_{$language.id}}</div>
    </div>
    {if $mykitty_href_{$language.id} != ""}</a>{/if}
	</div>
</div>