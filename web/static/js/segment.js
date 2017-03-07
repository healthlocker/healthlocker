export var Segment = {
  identify: function(id, name, email) {
    console.log("identify: " + id);
    console.log("identify: " + name);
    console.log("identify: " + email);

    analytics.identify(id, {
      name: name,
      email: email
    });
  }
}
