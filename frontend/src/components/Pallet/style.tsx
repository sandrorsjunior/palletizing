import styled from 'styled-components';

interface BoxProps{
    $color: string,
    $width: number,
    $height: number
    $x: number,
    $y: number,
    $margin_H: number,
    $margin_V: number
}

export const Box = styled.div<BoxProps>`
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    left: ${ props => props.$x}px;
    top: ${ props => props.$y}px;
    height:${ props => props.$height}px;
    width:${ props => props.$width}px;
    background-color:${ props => props.$color};

`

interface PalletProps{
    $color: string,
    $width: number,
    $height: number
}

export const Pallet = styled.div<PalletProps>`
    position: relative;
    height:${ props => props.$height}px;
    width:${ props => props.$width}px;
    background-color:${ props => props.$color};
    
`