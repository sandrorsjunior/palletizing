import React from 'react';
import styled from 'styled-components';

interface BoxProps{
    $color: string,
    $width: number,
    $height: number
}

export const Box = styled.div<BoxProps>`
    display: flex;
    justify-content: center;
    align-items: center;
    height:${ props => props.$height}px;
    width:${ props => props.$width}px;
    background-color:${ props => props.$color};
    border: 1px solid red;
    margin: 1rem;

`

interface PalletProps{
    $color: string,
    $width: number,
    $height: number
}

export const Pallet = styled.div<PalletProps>`
    display: flex;
    justify-content: center;
    align-items: center;
    height:${ props => props.$height}px;
    width:${ props => props.$width}px;
    background-color:${ props => props.$color};
    border: 1px solid red;
    
`