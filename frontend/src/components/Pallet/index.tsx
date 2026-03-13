import { Box, Pallet } from "./style";
import React from 'react';

interface boxProps {
    index: string,
    color: string,
    width: number,
    height: number,
    x: number,
    y: number,
    margin_H: number,
    margin_V: number
}

type BoxConfig = {
        quantite: {row: number, column: number},
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
            $x={boxProps.x}
            $y={boxProps.y}
            $margin_H={boxProps.margin_H}
            $margin_V={boxProps.margin_V}
        >
            {boxProps.index}
        </Box>
    )
}

export const PalletComponent = (palletProps: PalletProps) => {
    const boxes: React.JSX.Element[] = []
    for (let row = 0; row < palletProps.box.quantite.row; row++) {
        for (let column = 0; column < palletProps.box.quantite.column; column++) {
            const key = `R${row}_C${column}`
            // Cálculo das coordenadas (pode ser substituído por coordenadas fornecidas explicitamente no futuro)
            let x = column * (palletProps.box.boxProps.width + palletProps.box.boxProps.margin_H) + palletProps.box.boxProps.x;
            let y = row * (palletProps.box.boxProps.height + palletProps.box.boxProps.margin_V) + palletProps.box.boxProps.y;
            console.log(x, y)

            boxes.push(<BoxComponent
                key={key}
                index={`R${row}_C${column}`}
                color={palletProps.box.boxProps.color}
                width={palletProps.box.boxProps.width}
                height={palletProps.box.boxProps.height}
                x={x}
                y={y}
                margin_H={palletProps.box.boxProps.margin_H}
                margin_V={palletProps.box.boxProps.margin_V}
            />)
        }
    }


    return (
        <Pallet 
            $color={palletProps.color}
            $width={palletProps.width}
            $height={palletProps.height}
        >
            {boxes}
        </Pallet>
    )
}
