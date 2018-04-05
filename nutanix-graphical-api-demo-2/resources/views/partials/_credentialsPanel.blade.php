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
                    {!! Form::hidden( '_token', csrf_token(), [ 'id' => '_token', 'name' => '_token' ] ) !!}
                </div>
            </div>
        </div>
    </form>
</div>