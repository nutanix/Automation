/*
Application Environment helper
*/
module.exports = {
	restUrl: 'https://' + process.env.CLUSTER_IP + ':9440/api/nutanix',
	authorizationURL: 'https://' + process.env.CLUSTER_IP + ':9440/console/#page/authorize/',
	tokenURL: 'https://' + process.env.CLUSTER_IP + ':9440/api/nutanix/v3/oauth/token',
	clientID: process.env.CLIENT_ID,
	clientSecret: process.env.CLIENT_SECRET,
	appBaseUrl: 'http://' + process.env.CONTAINTER_VM_IP + ':' + process.env.PORT, 
}