package com.ejemplo.app.controller;

import com.ejemplo.app.model.Producto;
import com.ejemplo.app.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/productos")
public class ProductoController {

    @Autowired
    private ProductoRepository productoRepository;

    // GET todos
    @GetMapping
    public List<Producto> getAllProductos() {
        return productoRepository.findAll();
    }

    // GET por id
    @GetMapping("/{id}")
    public Optional<Producto> getProductoById(@PathVariable Long id) {
        return productoRepository.findById(id);
    }

    // POST crear
    @PostMapping
    public Producto createProducto(@RequestBody Producto producto) {
        return productoRepository.save(producto);
    }

    // DELETE eliminar
    @DeleteMapping("/{id}")
    public void deleteProducto(@PathVariable Long id) {
        productoRepository.deleteById(id);
    }
}
