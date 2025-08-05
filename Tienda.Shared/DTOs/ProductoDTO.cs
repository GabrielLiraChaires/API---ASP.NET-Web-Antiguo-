using System.ComponentModel.DataAnnotations;

namespace Tienda.Shared.DTOs
{
    public class ProductoDTO
    {
        [Required]
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio.")]
        [StringLength(100, ErrorMessage = "El nombre no puede exceder 100 caracteres.")]
        public string? Nombre { get; set; }

        [Required(ErrorMessage = "El costo es obligatorio.")]
        [Range(0.01, 99999999.99, ErrorMessage = "El costo debe estar entre 0.01 y 99,999,999.99.")]
        [DataType(DataType.Currency)]
        public decimal Costo { get; set; }

        [Required(ErrorMessage = "La cantidad es obligatoria.")]
        [Range(0, int.MaxValue, ErrorMessage = "La cantidad no puede ser negativa.")]
        public int Cantidad { get; set; }
    }
}