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