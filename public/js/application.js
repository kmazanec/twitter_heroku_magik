function Tweet(text){
  this.text = text;
}

Tweet.prototype.toHTML = function() {
  return "<li>"+this.text+"</li>";
};



$(document).ready(function() {

  $("#post_new_tweet").on("submit", function(event){
    event.preventDefault();
    url = $(this).attr("action");
    console.log(url);
    data = $(this).serialize();
    console.log(data);

    new_tweet = new Tweet($(this).find("#new_tweet").val());

    
    $.post(url, data, function(response){
      $("#response_message").text(response);
      $("#post_new_tweet").trigger("reset");
      $("#recent_tweets ul").append(new_tweet.toHTML());
    });

  });

});
