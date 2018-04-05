// Copyright (c) 2016 Nutanix Inc. All rights reserved.
//
// Lenovo Prism App
//

//-----------------------------------------------------------------------------
// Prism App Functions
//-----------------------------------------------------------------------------

// Called by the Prism applet container to bootstrap the app
function initialize() {
  if (isReadyToBeInitialized) {
    // TODO: Modify this based on your app.
    fetchData();
  } else {
    console.log('Prismlet is not ready to be initialized yet.');
  }
}

// Fetches and renders the data via the Prism APIFactory
function fetchData() {
  // Fetch VM and Host
  var entitiesToFetch = [
    Prism.APIFactory.ENTITY_TYPES.HOSTS
  ];

  // Fetch entities by deferred pattern
  var deferreds = [];
  _.each(entitiesToFetch, function(entityType) {

    var jqXhr = Prism.APIFactory.fetch({
      entityType: entityType,
      success: function(collection) {
        console.log('Successful fetch of '+ entityType);
      },
      error: function(response) {
        console.log('Prismlet Error: ', response);
      }
    });

    deferreds.push(jqXhr);

  }, this);

  // Apply $.when
  var _this = this;
  $.when.apply($, deferreds)
    .done(function(hostResult) {
      console.log('Prism Apps:', hostResult);
    });
}