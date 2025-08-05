using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using Tienda.Shared.DTOs;

namespace Tienda.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductoController : Controller
    {
        private readonly string conexion;

        public ProductoController(IConfiguration config)
        {
            conexion = config.GetConnectionString("DefaultConnection");
        }

        [HttpGet("Consultar")]
        public async Task<IActionResult> Consultar()
        {
            var responseAPI = new ResponseAPI<List<ProductoDTO>>();
            try
            {
                await using var conn = new SqlConnection(conexion);
                // Dapper para simplificar el mapeo de filas a DTOs.
                var lista = (await conn.QueryAsync<ProductoDTO>("sp_ConsultarProductos", commandType: CommandType.StoredProcedure)).ToList();

                responseAPI.EsCorrecto = true;
                responseAPI.Valor = lista;
                return StatusCode(StatusCodes.Status200OK, responseAPI);
            }
            catch (Exception ex)
            {
                responseAPI.EsCorrecto = false;
                responseAPI.Mensaje = "Ocurrió un error al cargar los productos. Detalles: " + ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, responseAPI);
            }
        }

        [HttpGet("Buscar/{id}")]
        public async Task<IActionResult> Buscar(int id)
        {
            var responseAPI = new ResponseAPI<ProductoDTO>();
            try
            {
                await using var conn = new SqlConnection(conexion);
                // Dapper para simplificar el mapeo de filas a DTOs.
                var resultado = await conn.QueryFirstOrDefaultAsync<ProductoDTO>("sp_BuscarProducto", new { Id = id }, commandType: CommandType.StoredProcedure);

                if (resultado == null)
                {
                    responseAPI.EsCorrecto = false;
                    responseAPI.Mensaje = "Producto no encontrado";
                    return NotFound(responseAPI);
                }

                responseAPI.EsCorrecto = true;
                responseAPI.Valor = resultado;
                return StatusCode(StatusCodes.Status200OK, responseAPI);
            }
            catch (Exception ex)
            {
                responseAPI.EsCorrecto = false;
                responseAPI.Mensaje = "Error al buscar el producto. Detalles: " + ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, responseAPI);
            }
        }

        [HttpPost("Guardar")]
        public async Task<IActionResult> Guardar([FromBody] ProductoDTO productoDTO)
        {
            var responseAPI = new ResponseAPI<ProductoDTO>();
            try
            {
                await using var conn = new SqlConnection(conexion);

                var parametros = new
                {
                    Nombre = productoDTO.Nombre,
                    Costo = productoDTO.Costo,
                    Cantidad = productoDTO.Cantidad
                };

                // Dapper para simplificar el mapeo de filas a DTOs.
                var resultado = await conn.QueryFirstOrDefaultAsync<ProductoDTO>(
                    "sp_GuardarProducto",
                    parametros,
                    commandType: CommandType.StoredProcedure
                );

                responseAPI.EsCorrecto = true;
                responseAPI.Valor = resultado;
                responseAPI.Mensaje = $"El producto {productoDTO.Nombre} fue almacenado correctamente.";
                return StatusCode(StatusCodes.Status200OK, responseAPI);
            }
            catch (Exception ex)
            {
                responseAPI.EsCorrecto = false;
                responseAPI.Mensaje = "Error al guardar el producto. Detalles: " + ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, responseAPI);
            }
        }

        [HttpPut("Actualizar")]
        public async Task<IActionResult> Actualizar([FromBody] ProductoDTO productoDTO)
        {
            var responseAPI = new ResponseAPI<ProductoDTO>();
            try
            {
                await using var conn = new SqlConnection(conexion);

                var parametros = new
                {
                    Id = productoDTO.Id,
                    Nombre = productoDTO.Nombre,
                    Costo = productoDTO.Costo,
                    Cantidad = productoDTO.Cantidad
                };

                var resultado = await conn.QueryFirstOrDefaultAsync<ProductoDTO>(
                    "sp_ActualizarProducto",
                    parametros,
                    commandType: CommandType.StoredProcedure
                );

                if (resultado == null)
                {
                    responseAPI.EsCorrecto = false;
                    responseAPI.Mensaje = "Producto no encontrado para actualizar.";
                    return NotFound(responseAPI);
                }

                responseAPI.EsCorrecto = true;
                responseAPI.Valor = resultado;
                responseAPI.Mensaje = $"El producto {productoDTO.Nombre} fue actualizado correctamente.";
                return StatusCode(StatusCodes.Status200OK, responseAPI);
            }
            catch (Exception ex)
            {
                responseAPI.EsCorrecto = false;
                responseAPI.Mensaje = "Error al actualizar el producto. Detalles: " + ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, responseAPI);
            }
        }

    }
}
