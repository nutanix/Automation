var express = require('express');
var request = require('request');

var tokenStore = require('../lib/token_store'),
	appEnv = require('../lib/app_env');


var router = express.Router();


router.get('/', function(req, res, next) {
	var token = tokenStore.getInstance().getToken();
	var api = '/v3/users/me';
	
	request.get(appEnv.restUrl + api, function (error, response, body) {
			if(error) {
				console.error('Error in fetching data:', err);
				return res.redirect('/');
			}

      var user_data=null;
			try{
				user_data=JSON.parse(body);
			}
			catch(e){
				console.error('Error in parsing response', e);
			}
	    
	    res.render('users', { 
	    	title: "User Permissions", 
	    	user_data: user_data, 
	    	api: api });

    }).auth(null, null, true, token.accessToken);
});

module.exports = router;
