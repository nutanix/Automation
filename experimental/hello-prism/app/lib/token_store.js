/*
Token store class
*/
var TokenStore = function() {
	this.token = null;
};

TokenStore.prototype.storeToken = function(token) {
	this.token=token;
};

TokenStore.prototype.getToken = function() {
	return this.token;
};

var _tokenInst = null;

function getInstance() {
	if(!_tokenInst) {
		_tokenInst = new TokenStore();
	}
	return _tokenInst;
};

module.exports = {
	getInstance: getInstance
}
