Parse.Cloud.define("incrementLikes", async(request) => {
	var query = new Parse.Query(Parse.User);
	query.equalTo("objectId", request.params.objectId)
    const results = await query.find()
    let object = results[0];
    console.log(object);
	// Queries user to be updated
	object.increment("favoriteCount");

	// Updates user (using MasterKey to get permission to update non logged in users)
	object.save(null, { useMasterKey: true }).then(function() {
		response.success();
	}, function(error) {
		response.error(error);
	});

    return object;

});

Parse.Cloud.define("decrementLikes", async(request) => {
	var query = new Parse.Query(Parse.User);
	query.equalTo("objectId", request.params.objectId)
    const results = await query.find()
    let object = results[0];
    console.log(object);
	// Queries user to be updated
	object.increment("favoriteCount", -1);

	// Updates user (using MasterKey to get permission to update non logged in users)
	object.save(null, { useMasterKey: true }).then(function() {
		response.success();
	}, function(error) {
		response.error(error);
	});

    return object;

});
