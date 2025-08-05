<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="Tienda.Client.Productos" Async="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Listado de Productos</h2>
        <hr />
        <%--GridView--%>
        <asp:GridView 
            runat="server" 
            ID="gvProductos" 
            AutoGenerateColumns="false" 
            OnSelectedIndexChanged="gvProductos_SelectedIndexChanged"
            DataKeyNames="Id">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" />
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                <%--Formatea el costo a dos decimales y HtmlEncode permite que el $ no se escape como texto plano.--%>
                <asp:BoundField DataField="Costo" HeaderText="Costo" DataFormatString="${0:N2}" HtmlEncode="false" />
                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" />
                <asp:CommandField ShowSelectButton="True" SelectText="Editar" />
            </Columns>
        </asp:GridView>
        <%--Formulario--%>
        <hr />

        <h2 id="tituloForm" runat="server">Nuevo Producto</h2>
        <asp:HiddenField runat="server" ID="hfId" />

        <asp:Label runat="server" Text="Nombre:" AssociatedControlID="txtNombre" /><br />
        <asp:TextBox runat="server" ID="txtNombre" /><br />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es obligatorio." ForeColor="Red" Display="Dynamic" /><br />

        <asp:Label runat="server" Text="Costo:" AssociatedControlID="txtCosto" /><br />
        <asp:TextBox runat="server" ID="txtCosto" /><br />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCosto" ErrorMessage="El costo es obligatorio." ForeColor="Red" Display="Dynamic" /><br />

        <asp:Label runat="server" Text="Cantidad:" AssociatedControlID="txtCantidad" /><br />
        <asp:TextBox runat="server" ID="txtCantidad" /><br />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCantidad" ErrorMessage="La cantidad es obligatoria." ForeColor="Red" Display="Dynamic" />
        <asp:RangeValidator runat="server" ControlToValidate="txtCantidad" MinimumValue="0" MaximumValue="2147483647" Type="Integer" ErrorMessage="La cantidad debe ser un número entero." ForeColor="Red" Display="Dynamic" /><br /><br />

        <asp:Button runat="server" ID="btnGuardar" Text="Guardar" OnClick="btnGuardar_Click" />
        <asp:Button runat="server" ID="btnActualizar" Text="Actualizar" OnClick="btnActualizar_Click" Visible="false" />
        <asp:Button runat="server" ID="btnCancelar" Text="Cancelar" OnClick="btnCancelarActualizacion_Click" Visible="false" />

        <asp:Label ID="lblMensaje" runat="server" ForeColor="Red" Font-Bold="true" EnableViewState="false"></asp:Label><br />
    </form>
</body>
</html>
