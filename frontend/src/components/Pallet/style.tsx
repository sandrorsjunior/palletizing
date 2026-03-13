import styled from 'styled-components';

interface BoxProps{
    $color: string,
    $width: number,
    $height: number
    $x: number,
    $y: number,
    $margin_H: number,
    $margin_V: number,
    $origin?: 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'
}

export const Box = styled.div<BoxProps>`
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    ${({ $origin, $x, $y }) => {
        switch ($origin) {
            case 'bottom-left':
                return `left: ${$x}px; bottom: ${$y}px;`;
            case 'bottom-right':
                return `right: ${$x}px; bottom: ${$y}px;`;
            case 'top-right':
                return `right: ${$x}px; top: ${$y}px;`;
            case 'top-left':
            default:
                return `left: ${$x}px; top: ${$y}px;`;
        }
    }}
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