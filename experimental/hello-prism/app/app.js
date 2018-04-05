var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var passport = require('passport');

var oauth = require('./lib/oauth');
var tokenStore = require('./lib/token_store')
var routes = require('./routes/index');
var users = require('./routes/users');

//To allow self signed certificates
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

var app = express();

//Init passport
app.use(passport.initialize());
app.use(passport.session());

// Register oauth strategy
oauth.register();

// Initialize token store
token_store = tokenStore.getInstance();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/auth/provider', passport.authenticate('provider', { scope: 'all' }));
app.get('/auth/provider/callback',
  passport.authenticate('provider', { successRedirect: '/users',
                                      failureRedirect: '/' }));


app.use('/', routes);

var auth_route = function(req, res, next) { 
  if (token_store.getToken() == null) 
    res.redirect('/auth/provider'); 
  else 
    next(); 
}

app.use('/users', auth_route, users);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});

passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(user, done) {
  done(null, user);
});


module.exports = app;
