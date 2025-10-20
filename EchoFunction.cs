using System.Net;
using System.Text.Json;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace EchoFunction;

public class EchoFunction
{
    private readonly ILogger _logger;

    public EchoFunction(ILoggerFactory loggerFactory)
    {
        _logger = loggerFactory.CreateLogger<EchoFunction>();
    }

    [Function("Echo")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "echo")] HttpRequestData req)
    {
        _logger.LogInformation("Echo function processed a request.");

        try
        {
            // Read the request body
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            
            if (string.IsNullOrEmpty(requestBody))
            {
                var badRequestResponse = req.CreateResponse(HttpStatusCode.BadRequest);
                await badRequestResponse.WriteStringAsync("Request body cannot be empty");
                return badRequestResponse;
            }

            // Create the echo response
            var echoResponse = new
            {
                message = "Echo successful",
                originalMessage = requestBody,
                timestamp = DateTime.UtcNow,
                requestId = Guid.NewGuid().ToString()
            };

            // Create successful response
            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "application/json; charset=utf-8");
            
            await response.WriteStringAsync(JsonSerializer.Serialize(echoResponse, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                WriteIndented = true
            }));

            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing echo request");
            
            var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            await errorResponse.WriteStringAsync("An error occurred while processing your request");
            return errorResponse;
        }
    }
}