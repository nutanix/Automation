var passport = require('passport')
  , OAuth2Strategy = require('passport-oauth').OAuth2Strategy
  , tokenStore = require('./token_store')
  , appEnv = require('./app_env');

function register() {
  passport.use('provider', new OAuth2Strategy({
      authorizationURL: appEnv.authorizationURL,
      tokenURL: appEnv.tokenURL,
      clientID: appEnv.clientID,
      clientSecret: appEnv.clientSecret,
      callbackURL: appEnv.appBaseUrl + '/auth/provider/callback'
    },
    function(accessToken, refreshToken, profile, done) {
      token = {
        accessToken: accessToken,
        refreshToken: refreshToken,
        profile: profile
      };
      tokenStore.getInstance().storeToken(token);
      done(null, accessToken);
    }
  ));
};


module.exports = {
  register: register
}