import { Box, Pallet } from "./style";
import React from 'react';

interface boxProps {
    index: string,
    color: string,
    width: number,
    height: number
}

type BoxConfig = {
        quantite: number,
        boxProps: boxProps
    }
interface PalletProps{
    box: BoxConfig,
    width: number,
    height: number,
    color: string,
    label: string,
}


export const BoxComponent = (boxProps: boxProps) => {
    return (
        <Box
            $color={boxProps.color}
            $width={boxProps.width}
            $height={boxProps.height}
        >
            {boxProps.index}
        </Box>
    )
}

export const PalletComponent = (palletProps: PalletProps) => {
    const boxes: React.JSX.Element[][] = []
    for (let row = 0; row < palletProps.box.quantite; row++) {
        const newRow: React.JSX.Element[] = []
        for (let column = 0; column < palletProps.box.quantite; column++) {
            const key = `R${row}_C${column}`
            newRow.push(<BoxComponent
                key={key}
                index={`R${row}_C${column}`}
                color={palletProps.box.boxProps.color}
                width={palletProps.box.boxProps.width}
                height={palletProps.box.boxProps.height}
            />)
        }
        boxes.push(newRow)
    }

    return (
        <Pallet 
            $color={palletProps.color}
            $width={palletProps.width}
            $height={palletProps.height}
        >
            {boxes.map((row, i) => (
            <div key={`row-${i}`} style={{ display: 'flex' }}>
                {row}
            </div>
        ))}
        </Pallet>
    )
}
