<div class="row" style="margin-top: 15px;">
    <div class="col-md-8 col-md-offset-2">

        <div id="clusterDetails" class="none">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Cluster Details [ <span id="cluster-name"></span> | <span
                                id="cluster-id"></span> ]</h3>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-4 item-header">Acropolis Base Version</div>
                        <div class="col-md-4 item-header">Nodes</div>
                        <div class="col-md-4 item-header">Hypervisor(s)</div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 item-content"><span id="cluster-nosVersion"></span></div>
                        <div class="col-md-4 item-content"><span id="cluster-numNodes"></span></div>
                        <div class="col-md-4 item-content"><span id="hypervisors"></span></div>
                    </div>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Cluster Storage</h3>
                </div>
                <!--
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-6" id="ssd_graph"></div>
                        <div class="col-md-6" id="hdd_graph"></div>
                    </div>
                </div>
                -->
                <table class="table" id="containers">
                    <tr>
                        <td>Name</td>
                        <td>RF</td>
                        <td>Compression</td>
                        <td>Comp. Delay (Minutes)</td>
                        <td>RAM/SSD Dedupe?</td>
                        <td>HDD Dedupe?</td>
                    </tr>
                </table>
            </div>


            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Cluster Configuration [ <span id="cluster-IP"></span> ]</h3>
                </div>
                <div class="panel-body">
                    Shadow Clones Enabled: <span id="cluster-enableShadowClones"></span><br>
                    Self-encrypting drives installed? <span id="cluster-hasSED"></span><br>
                </div>
            </div>

        </div>

        <div id="clusterError" class="panel panel-default ui-state-error none">
            <div class="panel-heading">
                <h3 class="panel-title">Cluster Error</h3>
            </div>
            <div class="panel-body">
                <p>An error has occurred while processing this request.</p>
                <p>Error details are as follows:</p>
                <p><span id="cluster-error"></span></p>
            </div>
        </div>

    </div>
</div>