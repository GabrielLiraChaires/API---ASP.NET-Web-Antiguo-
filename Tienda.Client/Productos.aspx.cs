using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Http.Json;
using Tienda.Client.DTOs;

namespace Tienda.Client
{
    public partial class Productos : System.Web.UI.Page
    {
        private static readonly HttpClient _http = new HttpClient
        {
            BaseAddress = new Uri("https://localhost:7159/api/Producto/")  
        };
        protected async void Page_Load(object sender, EventArgs e)
        {
            await CargarProductos();
        }

        //Métodos.
        protected async Task CargarProductos()
        {
            var respuesta = await _http.GetFromJsonAsync<ResponseAPI<List<ProductoDTO>>>("Consultar");
            Console.WriteLine(respuesta);
            if (respuesta != null && respuesta.EsCorrecto)
            {
                gvProductos.DataSource = respuesta.Valor;
                gvProductos.DataBind();
            }
            else
            {
                lblMensaje.Text = respuesta.Mensaje;
            }
        }
        private void LimpiarFormulario()
        {
            hfId.Value = "";
            txtNombre.Text = "";
            txtCosto.Text = "";
            txtCantidad.Text = "";
        }


        //Eventos.
        protected async void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            var nuevoProducto = new ProductoDTO
            {
                Nombre = txtNombre.Text,
                Costo = decimal.Parse(txtCosto.Text),
                Cantidad = int.Parse(txtCantidad.Text)
            };

            var respuestaHttp = await _http.PostAsJsonAsync("Guardar", nuevoProducto);
            var resultadoApi = await respuestaHttp.Content.ReadFromJsonAsync<ResponseAPI<ProductoDTO>>();

            if (resultadoApi.EsCorrecto)
            {
                await CargarProductos();
                LimpiarFormulario();
                lblMensaje.Text = resultadoApi.Mensaje;
                lblMensaje.ForeColor = System.Drawing.Color.Green;
                Response.Redirect(Request.RawUrl);
            }
            else
            {
                lblMensaje.Text = resultadoApi.Mensaje;
                lblMensaje.ForeColor = System.Drawing.Color.Red;
            }
        }
        protected async void btnActualizar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            var productoActualizar = new ProductoDTO
            {
                Id = int.Parse(hfId.Value),
                Nombre = txtNombre.Text,
                Costo = decimal.Parse(txtCosto.Text),
                Cantidad = int.Parse(txtCantidad.Text)
            };

            var respuestaHttp = await _http.PutAsJsonAsync("Actualizar", productoActualizar);
            var resultadoApi = await respuestaHttp.Content.ReadFromJsonAsync<ResponseAPI<ProductoDTO>>();

            if (resultadoApi.EsCorrecto)
            {
                await CargarProductos();
                LimpiarFormulario();
                btnGuardar.Visible = true;
                btnActualizar.Visible = false;
                tituloForm.InnerText = "Nuevo Producto";
                lblMensaje.Text = resultadoApi.Mensaje;
                lblMensaje.ForeColor = System.Drawing.Color.Green;
                Response.Redirect(Request.RawUrl);
            }
            else
            {
                lblMensaje.Text = resultadoApi.Mensaje;
                lblMensaje.ForeColor = System.Drawing.Color.Red;
            }
        }
        protected async void btnCancelarActualizacion_Click(object sender, EventArgs e)
        {
            await CargarProductos();
            LimpiarFormulario();
            btnGuardar.Visible = true;
            btnActualizar.Visible = false;
            btnCancelar.Visible = false;
            tituloForm.InnerText = "Nuevo Producto";
        }
        protected async void gvProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idSeleccionado = (int)gvProductos.SelectedDataKey.Value;

            var respuestaApi = await _http.GetFromJsonAsync<ResponseAPI<ProductoDTO>>($"Buscar/{idSeleccionado}");

            if (respuestaApi.EsCorrecto)
            {
                ProductoDTO producto = respuestaApi.Valor;

                hfId.Value = producto.Id.ToString();  
                txtNombre.Text = producto.Nombre;
                txtCosto.Text = producto.Costo.ToString();
                txtCantidad.Text = producto.Cantidad.ToString();

                btnGuardar.Visible = false;     
                btnActualizar.Visible = true;   
                btnCancelar.Visible = true;
                tituloForm.InnerText = $"Actualizando {producto.Nombre}"; 
            }
        }

    }
}