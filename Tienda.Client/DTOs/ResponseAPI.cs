using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tienda.Client.DTOs
{
    public class ResponseAPI<T>
    {
        public bool EsCorrecto { get; set; }
        public T Valor { get; set; }
        public string Mensaje { get; set; }
    }
}