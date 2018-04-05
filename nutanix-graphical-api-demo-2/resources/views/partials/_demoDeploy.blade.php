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
            <div class="alert alert-warning need-details">Need cluster details?
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