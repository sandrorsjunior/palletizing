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
            height: 50,
            margin_H: 5,
            margin_V: 5,
            x: 0,
            y: 0
          }
        }}
        width={300}
        height={300}
        color={"#3498db"}
        label={"Pallet 1"}
        origin="bottom-right"
      />
    </WorkSpace>
  )
}

export default App
