<!doctype html>

<html lang="en-us">

<head>
	<meta charset="utf-8">
	<title>Nutanix API Testing</title>
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/jquery-ui.css">
	<link rel="stylesheet" href="css/master.css">
</head>

<body>

<script>

</script>

<?php

require './vendor/autoload.php';

?>

<div class="container">

	<form id="api-form">
	
	<h1>Nutanix API Testing</h1>

	<div class="panel panel-default">
		<div class="panel-heading"><h2>Credentials</h2></div>
		<div class="panel-body">
			<div class="row">
				<div class="col-md-4">
					<label for="cluster_ip">Cluster IP:</label>
				</div>
				<div class="col-md-8">
					<input class="form-control" type="text" name="cluster_ip" id="cluster_ip">
				</div>
			</div>
			<div class="row">
				<div class="col-md-4">
					<label for="cluster_username">Cluster Username:</label>
				</div>
				<div class="col-md-8">
					<input class="form-control" type="text" name="cluster_username" id="cluster_username">
				</div>
			</div>
			<div class="row">
				<div class="col-md-4">
					<label for="cluster_password">Cluster Password:</label>
				</div>
				<div class="col-md-8">
					<input class="form-control" type="password" name="cluster_password" id="cluster_password">
				</div>
			</div>
		</div>
	</div>

	<div class="panel panel-default">
		<div class="panel-heading"><h2>API Details</h2></div>
		<div class="panel-body">
			<div class="row">
				<div class="col-md-12">
					<p>Note: All API calls entered below will be executed as child namespaces of <em>/PrismGateway/services/rest/v1/</em>.</p>
				</div>
			</div>
			<div class="row">
				<div class="col-md-4">
					<label for="cluster_ip">API Top-level Object</label>
				</div>
				<div class="col-md-8">
					<input class="form-control" type="text" name="api_top_level_object" id="api_top_level_object">
					<div class="small" id="object_explanation">E.g. cluster, containers</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-2 col-md-offset-5">
					<button class="btn btn-primary" id="api_go">Go!</button>
				</div>
			</div>
		</div>
	</div>

	</form>

	<div class="panel panel-primary">
		<div class="panel-heading"><h2>Raw API Output</h2></div>
		<div class="panel-body">
			<div class="row">
				<div class="col-md-10 col-md-offset-1" id="api_output">
					...
				</div>
			</div>
		</div>
	</div>
	
</div>

<div id="dialog_missing_info" class="none">
	<p class="h2">Awww!</p>
	<p>You're missing some required info.  Please check your input, then try again.</p>
</div>

<script src="js/jquery-1.12.3.min.js"></script>
<script src="js/jquery-ui.min.js"></script>
<script src="js/run_prettify.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/script.js"></script>

</body>

</html>