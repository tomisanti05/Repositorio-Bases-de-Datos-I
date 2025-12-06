import mysql.connector
from mysql.connector import Error


# CONEXIÓN A LA BASE DE DATOS

def conectar():
    try:
        conexion = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="ventas_en_linea"
        )
        print("Conectado a MySQL\n")
        return conexion
    except mysql.connector.Error as err:
        print(f"❌ Error al conectar: {err}")
        exit()


# FUNCIONES DE OPERACIONES

def ver_productos(conn):
    try:
        cursor = conn.cursor()
        cursor.callproc('sp_ver_productos')
        
        for result in cursor.stored_results():
            productos = result.fetchall()
            print("\n--- LISTA DE PRODUCTOS ---")
            print(f"{'COD':<5} {'NOMBRE':<25} {'CATEGORIA':<15} {'STOCK':<5}")
            print("-" * 55)
            for prod in productos:
                print(f"{prod[0]:<5} {prod[1]:<25} {prod[2]:<15} {prod[3]:<5}")
            print("-" * 55)
            
        cursor.close()
    except Error as e:
        print(f"Error al ver productos: {e}")

def agregar_producto(conn, cod, nombre, categoria, stock):
    try:
        cursor = conn.cursor()
        args = (cod, nombre, categoria, stock)
        cursor.callproc('sp_agregar_producto', args)
        conn.commit()
        print(f"\n[OK] Producto '{nombre}' agregado correctamente.")
        cursor.close()
    except Error as e:
        print(f"\n[ERROR] No se pudo agregar el producto: {e}")

def actualizar_producto(conn, cod, nombre, categoria, stock):
    try:
        cursor = conn.cursor()
        args = (cod, nombre, categoria, stock)
        cursor.callproc('sp_actualizar_producto', args)
        conn.commit()
        print(f"\n[OK] Producto actualizado correctamente.")
        cursor.close()
    except Error as e:
        print(f"\n[ERROR] No se pudo actualizar el producto: {e}")

def eliminar_producto(conn, cod):
    try:
        cursor = conn.cursor()
        args = (cod,)
        cursor.callproc('sp_eliminar_producto', args)
        conn.commit()
        print(f"\n[OK] Producto eliminado correctamente.")
        cursor.close()
    except Error as e:
        print(f"\n[ERROR] No se pudo eliminar el producto: {e}")
    

def registrar_cliente(conn, nombre, apellido, email, direccion):
    try:
        cursor = conn.cursor()
        cursor.callproc('sp_registrar_cliente', (nombre, apellido, email, direccion))
        conn.commit()
        print("Cliente registrado correctamente.")
        cursor.close()
    except Error as e:
        print(f"Error: {e}")

def ver_todos_clientes(conn):
    try:
        cursor = conn.cursor()
        cursor.callproc('sp_listar_clientes')
        print("\n--- CLIENTES ---")
        for result in cursor.stored_results():
            for c in result.fetchall():
                # Formato simple: ID - Nombre Apellido - Email
                print(f"#{c[0]} {c[1]} {c[2]} | {c[3]}")
        cursor.close()
    except Error as e:
        print(f"Error: {e}")

def buscar_cliente_detalle(conn, id_cliente):
    try:
        cursor = conn.cursor()
        cursor.callproc('sp_buscar_cliente', (id_cliente,))
        
        encontrado = False
        for result in cursor.stored_results():
            datos = result.fetchone()
            if datos:
                encontrado = True
                print(f"\nCliente #{id_cliente}: {datos[0]} {datos[1]}")
                print(f"Email: {datos[2]} | Dirección: {datos[3]}")
        
        if not encontrado:
            print("Cliente no encontrado.")
        cursor.close()
    except Error as e:
        print(f"Error: {e}")


def actualizar_contacto_cliente(conn, id_cliente, nuevo_email, nueva_direccion):
    try:
        cursor = conn.cursor()
        cursor.callproc('sp_modificar_cliente', (id_cliente, nuevo_email, nueva_direccion))
        conn.commit()
        print("Datos actualizados correctamente.")
        cursor.close()
    except Error as e:
        print(f"Error: {e}")

def mostrar_clientes(con):
    cursor = con.cursor()
    cursor.execute("SELECT * FROM cliente")
    resultados = cursor.fetchall()

    print("\nCLIENTES REGISTRADOS:")
    for fila in resultados:
        print(f"ID: {fila[0]} | Nombre: {fila[1]} {fila[2]} | Email: {fila[3]} | Dirección: {fila[4]}")

    cursor.close()


def buscar_cliente_por_apellido(con):
    apellido = input("Ingrese el apellido a buscar: ")
    cursor = con.cursor()

    cursor.callproc("buscar_cliente_por_apellido", [apellido])

    print(f"\nRESULTADOS PARA '{apellido}':")
    for result in cursor.stored_results():
        for fila in result.fetchall():
            print(fila)

    cursor.close()


def buscar_producto_por_categoria(con):
    categoria = input("Ingrese la categoria: ")
    cursor = con.cursor()

    cursor.callproc("buscar_producto_por_categoria", [categoria])

    print(f"\nPRODUCTOS EN CATEGORIA: {categoria}")
    for result in cursor.stored_results():
        for fila in result.fetchall():
            print(fila)

    cursor.close()


def ver_ordenes_cliente(con):
    id_cliente = int(input("Ingrese ID del cliente: "))
    cursor = con.cursor()

    cursor.callproc("ver_ordenes_por_cliente", [id_cliente])

    print(f"\nORDENES DEL CLIENTE {id_cliente} ---")
    for result in cursor.stored_results():
        for fila in result.fetchall():
            print(fila)

    cursor.close()


def productos_mas_vendidos(con):
    cursor = con.cursor()
    cursor.callproc("productos_mas_vendidos")

    print("\nPRODUCTOS MAS VENDIDOS:")
    for result in cursor.stored_results():
        for fila in result.fetchall():
            print(f"Producto {fila[1]} | Total vendido: {fila[2]}")

    cursor.close()


def ver_pedidos_por_producto(con):
    cod = int(input("Ingrese codigo de producto: "))
    cursor = con.cursor()
    cursor.callproc("ver_pedidos_por_producto", [cod])

    print("\nPEDIDOS DEL PRODUCTO:")
    for result in cursor.stored_results():
        for fila in result.fetchall():
            print(fila)

    cursor.close()

def reporte_producto_mas_vendido(conn):
    try:
        cursor = conn.cursor()
        cursor.callproc('sp_reporte_mas_vendido')
        
        # Obtenemos el primer set de resultados
        resultados = next(cursor.stored_results(), None)
        
        if resultados:
            fila = resultados.fetchone()
            if fila:
                print(f"\n PRODUCTO ESTRELLA: {fila[0]}")
                print(f" Cantidad Total Vendida: {fila[1]} unidades")
            else:
                print("No hay suficientes datos de ventas para generar el reporte.")
        
        cursor.close()
    except Error as e:
        print(f"Error: {e}")

def modificar_orden(conn, id_orden, nueva_cantidad):
    try:
        cursor = conn.cursor()
        args = (id_orden, nueva_cantidad)
        cursor.callproc('sp_modificar_orden', args)
        conn.commit()
        print(f"\n[OK] Orden #{id_orden} actualizada a {nueva_cantidad} unidades.")
        cursor.close()
    except Error as e:
        print(f"\n[ERROR DE NEGOCIO] {e}")


# MENÚ CLI

def menu_clientes(conn):
    while True:
        print("\n===== MENU CLIENTES =====")
        print("1. Ver todos los clientes")
        print("2. Buscar cliente por apellido")
        print("3. Buscar cliente por ID (detalle)")
        print("4. Registrar nuevo cliente")
        print("5. Modificar contacto de cliente")
        print("0. Volver")

        opc = input("Seleccione una opción: ")

        if opc == "1":
            ver_todos_clientes(conn)
        elif opc == "2":
            buscar_cliente_por_apellido(conn)
        elif opc == "3":
            try:
                cid = int(input("ID Cliente: "))
                buscar_cliente_detalle(conn, cid)
            except:
                print("ID inválido.")
        elif opc == "4":
            nombre = input("Nombre: ")
            apellido = input("Apellido: ")
            email = input("Email: ")
            direccion = input("Dirección: ")
            registrar_cliente(conn, nombre, apellido, email, direccion)
        elif opc == "5":
            try:
                cid = int(input("ID Cliente: "))
                nuevo_email = input("Nuevo email: ")
                nueva_direccion = input("Nueva dirección: ")
                actualizar_contacto_cliente(conn, cid, nuevo_email, nueva_direccion)
            except:
                print("Datos inválidos.")
        elif opc == "0":
            break
        else:
            print("❌ Opción inválida.")


def menu_productos(conn):
    while True:
        print("\n===== MENÚ PRODUCTOS =====")
        print("1. Ver lista de productos")
        print("2. Buscar productos por categoría")
        print("3. Agregar producto")
        print("4. Actualizar producto")
        print("5. Eliminar producto")
        print("0. Volver")

        opc = input("Seleccione una opción: ")

        if opc == "1":
            ver_productos(conn)

        elif opc == "2":
            buscar_producto_por_categoria(conn)

        elif opc == "3":
            try:
                cod = int(input("Código: "))
                nombre = input("Nombre: ")
                categoria = input("Categoría: ")
                stock = int(input("Stock: "))
                agregar_producto(conn, cod, nombre, categoria, stock)
            except:
                print("Datos inválidos.")

        elif opc == "4":
            try:
                cod = int(input("Código a actualizar: "))
                nombre = input("Nuevo nombre: ")
                categoria = input("Nueva categoría: ")
                stock = int(input("Nuevo stock: "))
                actualizar_producto(conn, cod, nombre, categoria, stock)
            except:
                print("Datos inválidos.")

        elif opc == "5":
            try:
                cod = int(input("Código del producto a eliminar: "))
                eliminar_producto(conn, cod)
            except:
                print("Código inválido.")

        elif opc == "0":
            break
        else:
            print("❌ Opción inválida.")


def menu_ordenes(conn):
    while True:
        print("\n===== MENÚ ÓRDENES =====")
        print("1. Ver órdenes de un cliente")
        print("2. Ver pedidos por producto")
        print("3. Modificar cantidad de una orden")
        print("0. Volver")

        opc = input("Seleccione una opción: ")

        if opc == "1":
            ver_ordenes_cliente(conn)

        elif opc == "2":
            ver_pedidos_por_producto(conn)

        elif opc == "3":
            try:
                oid = int(input("ID de la orden: "))
                nueva_cant = int(input("Nueva cantidad: "))
                modificar_orden(conn, oid, nueva_cant)
            except:
                print("Datos inválidos.")

        elif opc == "0":
            break
        else:
            print("❌ Opción inválida.")


def menu_reportes(conn):
    while True:
        print("\n===== REPORTES =====")
        print("1. Productos más vendidos")
        print("2. Producto estrella (max ventas)")
        print("0. Volver")

        opc = input("Seleccione una opción: ")

        if opc == "1":
            productos_mas_vendidos(conn)
        elif opc == "2":
            reporte_producto_mas_vendido(conn)
        elif opc == "0":
            break
        else:
            print("❌ Opción inválida.")


#MENÚ PRINCIPAL

def mostrar_menu():
    print("\n======= SISTEMA DE VENTAS =======")
    print("1. Gestión de Clientes")
    print("2. Gestión de Productos")
    print("3. Gestión de Órdenes")
    print("4. Reportes")
    print("0. Salir")
    print("=================================")


def main():
    con = conectar()

    while True:
        mostrar_menu()
        opcion = input("Seleccione una opción: ")

        if opcion == "1":
            menu_clientes(con)

        elif opcion == "2":
            menu_productos(con)

        elif opcion == "3":
            menu_ordenes(con)

        elif opcion == "4":
            menu_reportes(con)

        elif opcion == "0":
            print("Saliendo...")
            con.close()
            break

        else:
            print("❌ Opción inválida.")


if __name__ == "__main__":
    main()