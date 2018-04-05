<!doctype html>

<html lang="en-us">

<head>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="css/smoothness/jquery-ui.min.css">
	<link rel="stylesheet" type="text/css" href="css/master.css">
	<link href='https://fonts.googleapis.com/css?family=Roboto:700' rel='stylesheet' type='text/css'>
	<link href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>
	<title>Nutanix REST API Demos</title>
</head>

<body style="">

<nav class="navbar navbar-default" role="navigation">
	<div class="container-fluid">
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="http://www.nutanix.com" target="_blank" title="Nutanix.com">Nutanix.com</a>
				</li>
				<li><a href="http://go.nutanix.com/rs/nutanix/images/Nutanix_Spec_Sheet.pdf" target="_blank"
				       title="Nutanix Spec Sheet">Nutanix Spec Sheet</a></li>
				<li><a href="http://www.nutanix.com/resources" target="_blank" title="Nutanix Resources">Nutanix
						Resources</a></li>
				<li><a href="http://www.nutanix.com/products/features/management-and-analytics/programmatic-interface/"
				       target="_blank" title="" Nutanix REST API">Nutanix REST API</a></li>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
					   aria-expanded="false">What the ... ? <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a id="set-contrast" href="#">Adjust Contrast ;)</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
</nav>

<div class="container-fluid">
	<div class="row">
		<div class="col-md-6">
			<form id="config-form">
				<div class="panel panel-default">
					<div class="panel-heading"><h2 class="step-heading">Step 1</h2>
						<div class="step-desc">Enter cluster details</div>
					</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-md-6">
								<div class="glyphicon glyphicon-heart"></div>
								&nbsp;<label for="cvm-address">Cluster/CVM Address</label>
								<input class="form-control" type="text" name="cvm-address" id="cvm-address" placeholder="Cluster or CVM address"/>
							</div>
							<div class="col-md-6">
								<div class="glyphicon glyphicon-log-in"></div>
								&nbsp;<label for="cvm-port">CVM Port</label>
								<input class="form-control" type="text" name="cvm-port" id="cvm-port" value="9440"/>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-md-4">
								<div class="glyphicon glyphicon-user"></div>
								&nbsp;<label for="cluster-username">Username</label>
								<input class="form-control" type="text" name="cluster-username" id="cluster-username" placeholder="Your cluster username"/>
							</div>
							<div class="col-md-4">
								<div class="glyphicon glyphicon-lock"></div>
								&nbsp;<label for="cluster-password">Password</label>
								<input class="form-control" type="password" name="cluster-password" id="cluster-password" placeholder="Your cluster password"/>
							</div>
							<div class="col-md-4">
								<div class="glyphicon glyphicon-time"></div>
								&nbsp;<label for="cluster-timeout">Timeout (seconds)</label>
								<input class="form-control" type="text" name="cluster-timeout" id="cluster-timeout" value="10"/>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
		<div class="col-md-6">
			<div class="panel panel-default">
				<div class="panel-heading"><h2 class="step-heading">Step 2</h2>
					<div class="step-desc">Select a demo</div>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-md-12">
							<form id="select-demo">
								<select class="form-control" name="select_demo" id="select_demo">
									<option value="demo-read">Get cluster details</option>
									<option value="demo-container">Create container</option>
									<option value="demo-shell">Create shell VM</option>
									<option value="demo-deploy">Deploy full VM w/ Cloud-Init</option>
									<option value="demo-raw">Dump RAW JSON Output</option>
								</select>
							</form>
							<div id="demo-read">This simple demo will perform a GET request against the specified
								cluster. If the request succeeds, various cluster configuration details will be
								displayed in the results panel below.
							</div>
							<div id="demo-container">
								<p>
									This is the first of the POST demos available. The container name provided will be
									used to create a new container, if that container does not already exist. Please
									note the container will be created in the first available storage pool, if one
									exists.
								</p>
								<label for="container-name">Container Name</label>
								<input class="form-control" type="text" name="container-name" id="container-name" placeholder="ContainerName"/>
								<div class="prefix good">Note: Container name entered above will be prefixed with "DEMO-&lt;date&gt;-" during the creation process.</div>
							</div>
							<div id="demo-shell">
								<p>
									This POST request will create an empty virtual machine matching the selected server
									profile. This demo is intended to show that we can create empty VMs for later
									customisation just by selecting a profile from the pre-populated list.
								</p>
								<label for="server-profile">Select Server Profile:</label>
								<select name="server-profile" id="server-profile" class="form-control">
									<option selected id="profile-exchange" value="exch">Microsoft Exchange 2013
										Mailbox
									</option>
									<option id="profile-dc" value="dc">Domain Controller</option>
									<option id="profile-web" value="lamp">Web Server (LAMP)</option>
								</select>
								<div class="get-profile" class="server-profile-list">
									<div id="profile--spec">&raquo;&nbsp;Microsoft Exchange specs: 2x CPU, 8GB
										RAM, 1x 120GB SCSI disk, 1x 500GB SCSI disk
									</div>
									<div id="profile-dc-spec" class="none">&raquo;&nbsp;Domain Controller
										specs: 1x CPU, 2GB RAM, 1x 250GB SCSI disk
									</div>
									<div id="profile-lamp-spec" class="none">&raquo;&nbsp;Web Server specs: 2x
										CPU, 4GB RAM, 1x 40GB disk
									</div>
								</div>
								<label for="server-name">Enter Server Name:</label>
								<input class="form-control" type="text" name="server-name" id="server-name"/>
								<div class="prefix good">Note: Server name entered above will be prefixed with "DEMO-&lt;date&gt;-" during the creation process.</div>
							</div>
							<div id="demo-deploy">
								<p>
									Because Nutanix supports Cloud-Init (and Sysprep), we can submit a POST request that
									will deploy an entire VM. This demo will clone an existing Linux VM and fully
									customise the clone from a Cloud-Init YAML file - all with 1 click.
								</p>
								<div class="row">
									<div class="col-md-6">
										<label for="server-profile-custom">Select Server Profile:</label>
										<select name="server-profile-custom" id="server-profile-custom"
										        class="form-control">
											<option selected id="profile-lamp" value="exch">Linux/Apache/MySQL/PHP
												(LAMP) Web
												Server
											</option>
										</select>
										<div class="get-profile-custom" class="server-profile-list">
											<div id="profile-lamp-spec">&raquo;&nbsp;LAMP specs: 1x CPU, 4GB RAM</div>
										</div>
									</div>
									<div class="col-md-6">
										<label for="server-name-custom">Enter Server Name:</label>
										<input class="form-control" type="text" name="server-name-custom" id="server-name-custom"/>
										<div class="prefix good">Note: Server name entered above will be prefixed with "DEMO-&lt;date&gt;-" during the creation process.</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-4">
										<label for="deploy-container">Container</label>
										<input type="text" name="deploy-container" id="deploy-container"
										       class="form-control" placeholder="Enter container name"/>
										<!--
										<select class="form-control" name="deploy-container" id="deploy-container">
										</select>
										-->
									</div>
									<div class="col-md-4">
										<label for="deploy-net-uuid">Network UUID</label>
										<input type="text" name="deploy-net-uuid" id="deploy-net-uuid"
										       class="form-control" placeholder="Enter network UUID">
									</div>
									<div class="col-md-4">
										<label for="deploy-disk-uuid">Disk UUID</label>
										<input type="text" name="deploy-disk-uuid" id="deploy-disk-uuid"
										       class="form-control" placeholder="Enter disk UUID">
									</div>
								</div>
								<div class="row center">
									<div id="deploy-expand">
										<div class="alert alert-info need-details">Need cluster details?
											Click here!
										</div>
									</div>
									<div id="deploy-details" class="left">
										<p>If you aren't sure which containers, virtual disks and networks are
											available, enter your cluster details &amp; click the &quot;Get Details&quot;
											button. Container, disk UUID and network UUID details for your cluster will
											be shown below, making it easier to populate the fields above.</p>
										<p>If you have lots of images, VMs &amp; networks, this list can be long ...</p>
										<p class="emphasised">To use a specific container, click the container
											name to populate the field above. To use a specific network or virtual disk,
											click the UUID to populate the fields above.</p>
										<div>
											<button class="btn btn-default" name="deploy-get-details"
											        id="deploy-get-details">Get Details
											</button>
											<div id="deploy-details-messages"></div>
										</div>
										<div id="deploy-details-results"></div>
									</div>
								</div>
							</div>
							<div id="demo-raw">
								<p>This isn't really a demo, in the normal sense.  The idea is to perform a GET request against the specified
								cluster but do nothing with the results other than display the raw JSON output. This is useful for testing API calls when you aren't sure of the results.</p>
								<div class="row">
									<div class="col-md-4">
										<label for="cluster_ip">API Top-level Object</label>
									</div>
									<div class="col-md-8">
										<input class="form-control" type="text" name="api-object" id="api-object">
										<div class="small" id="object-explanation">E.g. cluster, containers</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<button class="btn btn-primary" name="run-demo" id="run-demo">Run Demo</button>
					<div id="demo-messages">&nbsp;</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<div class="panel panel-default">
				<div class="panel-heading"><h2 class="step-heading">Step 3</h2>
					<div class="step-desc">Check out the results ...</div>
				</div>
				<div class="panel-body">
					<div id="result-messages">&nbsp;</div>
					<?php require_once( './output-templates/demo-read.php' ); ?>
					<?php require_once( './output-templates/demo-raw.php' ); ?>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="dialog-confirm" title="Continue?">
	<p><br>
	<div class="glyphicon glyphicon-question-sign"></div>
	&nbsp;Even though this is a demo application, you are about to
	make <strong>REAL</strong> changes to the cluster.&nbsp;&nbsp;Are you sure you want to do that?</p>
</div>

<script src="js/jquery-1.11.2.min.js"></script>
<script src="js/jquery-ui.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/run_prettify.js"></script>
<script src="js/script.js"></script>

<script>

</script>

</body>

</html>