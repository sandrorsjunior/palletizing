import './App.css'
import { Pallet } from './components/Pallet'

function App() {


  const myBoxConfig = {
    quantite: 2, // Isso criará uma grade de 5x5 (baseado no seu loop aninhado)
    boxProps: {
      index: "0", // O index é sobrescrito no loop, mas o tipo exige aqui
      color: "#f39c12", // Cor alaranjada para as caixas
      width: 2,
      height: 2
    }
  };

  return (
    <>
      <Pallet
        box={myBoxConfig}
        width={50}
        height={50}
        color={"#3498db"}
        label={"Pallet 1"}
      />
    </>
  )
}

export default App
