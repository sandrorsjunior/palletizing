import './App.css'
import { PalletComponent } from './components/Pallet'
import { WorkSpace } from './components/WorkSpace'

function App() {




  return (
    <WorkSpace>
      <PalletComponent
        box={{
          quantite: { row: 3, column: 3 },
          boxProps: {
            index: "0",
            color: "#f39c12",
            width: 50,
            height: 70,
            margin_H: 10,
            margin_V: 70,
            x: 30,
            y: 0
          }
        }}
        width={500}
        height={500}
        color={"#3498db"}
        label={"Pallet 1"}
      />
    </WorkSpace>
  )
}

export default App
