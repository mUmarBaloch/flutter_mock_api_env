class Api {
static String baseUrl = 'https://dc4d-111-88-122-90.ngrok-free.app';
static String loginEndpoint = "/token/login";
static String logoutEndpoint = "/token/logout";
static String transactionEndPoint = "/shop/api/sales/";
static Map<String,String> headers(token)=>{"Content-Type": "application/json",'Authorization':'Token $token'};
}