function setReqBody (requestParams, context, ee, next) {
  requestParams.body = {'email': 'user@mail.com', 'password': 'password', '_csrf_token': window.csrfToken};
  return next();
}

module.exports = {
  setReqBody: setReqBody
};
