export var Segment = {
  identify: function(id, name, email) {
    analytics.identify(id, {
      name: name,
      email: email
    });
  }
}
