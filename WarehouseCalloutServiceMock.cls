@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    global HttpResponse respond(HttpRequest request){
        
        System.assertEquals('https://th-superbadge-apex.herokuapp.com/equipment', request.getEndpoint());
        System.assertEquals('GET', request.getMethod());
        
    	// Create a fake response
		HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
		response.setBody('[{"_id":"5599733440022883faof","replacement":false,"quantity":3,"name":"inverter 2000 KW","maintenanceperiod":365,"lifespan":150,"cost":10000,"sku":"500002"}]');
        response.setStatusCode(200);
        return response;
    }
}