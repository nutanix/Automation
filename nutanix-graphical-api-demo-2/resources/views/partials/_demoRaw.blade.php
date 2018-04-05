<div id="demo-raw">
    <p>This isn't really a demo, in the normal sense.  The idea is to perform a GET or POST request against the specified
        cluster but do nothing with the results other than display the raw JSON output. This is useful for testing API calls when you aren't sure of the results.</p>
    <div class="row">
        <div class="col-md-12">
            <label for="request-type">Request Method</label>
            <select class="form-control" name="request-type" id="request-type">
                <option selected value="get">GET</option>
                <option value="post">POST</option>
            </select>
            <label for="api-object">Full API Request Path</label>
            <input class="form-control" type="text" name="api-object" id="api-object">
            <div class="small" id="object-explanation">
                <div>API v1 GET example: /PrismGateway/services/rest/v1/vms</div>
                <div>API v2.0 GET example: /api/nutanix/v2.0/storage_containers</div>
                <div>API v3 POST example: /api/nutanix/v3/clusters/list</div>
            </div>
            <label for="api-parameters">JSON Request Parameters</label>
            <textarea class="form-control" size="10" name="api-parameters" id="api-parameters"></textarea>
            <div class="small" id="parameters-explanation">
                <div>API v1 GET example: <em>Leave this empty - it will be ignored</em></div>
                <div>API v2.0 GET example: <em>Leave this empty - it will be ignored</em></div>
                <div>API v3 POST example: { "kind": "cluster", "length": 10, "offset": 0, "filter": "" }</div>
            </div>
        </div>
    </div>
</div>