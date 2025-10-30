class Nave {
  var velocidad = 0
  var direccionAlSol = 0
  var combustible = 0

  method cargarCombustible(cuanto) {
    combustible += cuanto
  }
  method descargarCombustible(cuanto) {
    combustible = 0.max(combustible-cuanto)
  }
  method acelerar(cuanto) {
    velocidad = 100000.min(velocidad + cuanto)
  }
  method desacelerar(cuanto) {
    velocidad = 0.max(velocidad - cuanto)
  }
  method irHaciaElSol() {direccionAlSol=10}
  method escaparDelSol() {direccionAlSol=-10}
  method ponerseParaleloAlSol() {direccionAlSol=0}
  method acercarseUnPocoAlSol() {
    direccionAlSol = (direccionAlSol + 1).min(10)
  }
  method alejarseUnPocoDelSol() {
    direccionAlSol = (direccionAlSol - 1).max(-10)
  }
  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.accionAdicional()
  }
  method accionAdicional() // abstracto
  method estaTranquila() {
    return
    combustible >= 4000 &&
    velocidad <= 12000 && 
    self.condicionAdicional()
  }
  method condicionAdicional() // abstracto
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method escapar()
  method avisar()
  method estaDeRelajo() {
    return
    self.estaTranquila() &&
    self.tienePocaActividad()
  }
  method tienePocaActividad()
}

class NaveBaliza inherits Nave {
  var colorBaliza
  var cambioBaliza = false
  method cambiarColorDeBaliza(colorNuevo) {
    colorBaliza = colorNuevo
    cambioBaliza = true
  }
  override method accionAdicional() {
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method condicionAdicional() {
    return colorBaliza != "rojo"
  }
  override method escapar() {
    self.irHaciaElSol()
  }
  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }
  override method tienePocaActividad() = not cambioBaliza
}

class NavePasajeros inherits Nave {
  const pasajeros
  var comida = 0
  var bebida = 0
  var comidaServida = 0
  method cargar(cantBebida,cantComida) {
    bebida = bebida + cantBebida
    comida = comida + cantComida
  }
  method descargar(cantBebida,cantComida) {
    bebida = 0.max(bebida - cantBebida)
    comida = 0.max(comida - cantComida)
    comidaServida += cantComida
  }
  override method accionAdicional() {
    self.cargar(6*pasajeros, 4*pasajeros)
    self.acercarseUnPocoAlSol()
  }
  override method condicionAdicional() {
    return true
  }
  override method escapar() {
    self.acelerar(velocidad)
  }
  override method avisar() {
    self.descargar(pasajeros*2, pasajeros)
  }
  override method tienePocaActividad() = comidaServida < 50
}

class NaveCombate inherits Nave {
  var invisible = true
  var misilesDesplegados = false
  const mensajes = []
  method ponerseVisible() {invisible=false}
  method ponerseInvisible() {invisible=true}
  method estaInvisible() = invisible
  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}
  method misilesDesplegados() = misilesDesplegados
  method emitirMensaje(mensaje) {
    mensajes.add(mensaje)
  }
  method mensajesEmitidos() = mensajes
  method cantMensajesEmitidos() = mensajes.size()
  method primerMensajeEmitido() {
    if(mensajes.isEmpty()) {
      self.error("Aún no hay mensajes emitidos")
    }
    return mensajes.first()
  }
  method ultimoMensajeEmitido() {
    if(mensajes.isEmpty()) {
      self.error("Aún no hay mensajes emitidos")
    }
    return mensajes.last()
  }
  method esEscueta() {
    return mensajes.all({m=>m.length()<30})
  }
  method emitioMensaje(mensaje) {
    return mensajes.contains(mensaje)
  }
  override method accionAdicional() {
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }
  override method condicionAdicional() {
    return not misilesDesplegados
  }
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }
  override method tienePocaActividad() = true
}

class NaveHospital inherits NavePasajeros {
  var quirofanosPreparados = false
  override method condicionAdicional() {
    return not quirofanosPreparados
  }
  method prepararQuirofanos() {quirofanosPreparados=true}
  override method recibirAmenaza() {
    super()
    self.prepararQuirofanos()
  }
  override method tienePocaActividad() = true
}

class NaveSigilosa inherits NaveCombate {
  override method condicionAdicional() {
    return super() && not self.estaInvisible()
  }
  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}