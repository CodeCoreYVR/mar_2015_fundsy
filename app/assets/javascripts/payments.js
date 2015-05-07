$(document).ready(function(){

  Stripe.setPublishableKey($("meta[name=stripe-key]").attr("content"));

  $("#stripe-form").submit(function(e){
    e.preventDefault();

    $("#stripe-errors").html("");
    $("input[type=submit]").attr("disabled", true);

    var card = {
      number: $("#_card_number").val(),
      cvc: $("#_cvc").val(),
      expMonth: $("#date_month").val(),
      expYear: $("#date_year").val()
    }

    Stripe.createToken(card, handleStripeResponse);
  });

  handleStripeResponse = function(status, response) {
    if(status === 200) {
      $("#_stripe_token").val(response.id);
      $("#token-form").submit();
    } else {
      $("#stripe-errors").html(response.error.message);
      $("input[type=submit]").attr("disabled", false);
    }
  }

});