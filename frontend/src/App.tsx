import './App.css'
import { PalletComponent } from './components/Pallet'

function App() {


  const myBoxConfig = {
    quantite: 2, // Isso criará uma grade de 5x5 (baseado no seu loop aninhado)
    boxProps: {
      index: "0", // O index é sobrescrito no loop, mas o tipo exige aqui
      color: "#f39c12", // Cor alaranjada para as caixas
      width: 50,
      height: 50
    }
  };

  return (
    <>
      <PalletComponent
        box={myBoxConfig}
        width={500}
        height={500}
        color={"#3498db"}
        label={"Pallet 1"}
      />
    </>
  )
}

export default App
