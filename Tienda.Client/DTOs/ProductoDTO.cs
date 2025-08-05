using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tienda.Client.DTOs
{
    public class ProductoDTO
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public decimal Costo { get; set; }
        public int Cantidad { get; set; }
    }
}