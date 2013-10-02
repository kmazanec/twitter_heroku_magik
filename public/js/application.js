function Tweet(text){
  this.text = text;
}

Tweet.prototype.toHTML = function() {
  return "<li>"+this.text+"</li>";
};

function removeMessage (){
  $("#response_message").empty();
}


$(document).ready(function() {

  $("#post_new_tweet").on("submit", function(event){
    event.preventDefault();
    $("#waiting").show();

    url = $(this).attr("action");
    console.log(url);
    data = $(this).serialize();
    console.log(data);

    new_tweet = new Tweet($(this).find("#new_tweet").val());

    if (new_tweet.length() > 140 ) {
      $("#response_message").text("Your tweet must be less than 140 chars, newb!");
    } else {
      $.post(url, data, function(response){
        $("#response_message").text(response);
        $("#post_new_tweet").trigger("reset");
        $("#recent_tweets ul").append(new_tweet.toHTML());
        $("#waiting").hide();
      });
    }
    window.setTimeout(removeMessage, 3000);
  });

});
