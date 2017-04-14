App.messages = App.cable.subscriptions.create('PicksChannel', {
  received: function(data) {
    $("#picks").removeClass('hidden')
    return $('#picks').append(this.renderPick(data));
  },

  renderPick: function(data) {
    return "<p> <b>" + data.user_id + ": </b>" + data.player_id + "</p>";
  }
});
