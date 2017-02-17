INCLUDE "components/battle/denjuu_portrait.inc"

SECTION "Denjuu Portrait Loader WRAM", WRAM0[$CB02]
W_Battle_SelectedPortraitBank: ds 1

SECTION "Denjuu Portrait Loader", ROM0[$1620]
;Loads the individual pictures of each denjuu from a massive 10-bank
;uncompressed graphics array. Seriously!
;TODO: Extract the Denjuu graphics so we can symbolize the bank numbers.
Battle_LoadDenjuuPortrait::
    push de
    cp M_Battle_DenjuuPortraitStride
    jp nc, .bank2Denjuu
    push af
    ld a, $6B
    jp .denjuuBankAndOffsetSelected
    
.bank2Denjuu
    cp M_Battle_DenjuuPortraitStride * 2
    jp nz, .bank3Denjuu
    sub M_Battle_DenjuuPortraitStride
    push af
    ld a, $6C
    jp .denjuuBankAndOffsetSelected
    
.bank3Denjuu
    cp M_Battle_DenjuuPortraitStride * 3
    jp nz, .bank4Denjuu
    sub M_Battle_DenjuuPortraitStride * 2
    push af
    ld a, $6D
    jp .denjuuBankAndOffsetSelected
    
.bank4Denjuu
    cp M_Battle_DenjuuPortraitStride * 4
    jp nz, .bank5Denjuu
    sub M_Battle_DenjuuPortraitStride * 3
    push af
    ld a, $6E
    jp .denjuuBankAndOffsetSelected
    
.bank5Denjuu
    cp M_Battle_DenjuuPortraitStride * 5
    jp nz, .bank6Denjuu
    sub M_Battle_DenjuuPortraitStride * 4
    push af
    ld a, $6F
    jp .denjuuBankAndOffsetSelected
    
.bank6Denjuu
    cp M_Battle_DenjuuPortraitStride * 6
    jp nz, .bank7Denjuu
    sub M_Battle_DenjuuPortraitStride * 5
    push af
    ld a, $70
    jp .denjuuBankAndOffsetSelected
    
.bank7Denjuu
    cp M_Battle_DenjuuPortraitStride * 7
    jp nz, .bank8Denjuu
    sub M_Battle_DenjuuPortraitStride * 6
    push af
    ld a, $71
    jp .denjuuBankAndOffsetSelected
    
.bank8Denjuu
    cp M_Battle_DenjuuPortraitStride * 8
    jp nz, .bank9Denjuu
    sub M_Battle_DenjuuPortraitStride * 7
    push af
    ld a, $72
    jp .denjuuBankAndOffsetSelected
    
.bank9Denjuu
    cp M_Battle_DenjuuPortraitStride * 9
    jp nz, .bank10Denjuu
    sub M_Battle_DenjuuPortraitStride * 8
    push af
    ld a, $73
    jp .denjuuBankAndOffsetSelected
    
.bank10Denjuu
    sub M_Battle_DenjuuPortraitStride * 9
    push af
    ld a, $74

.denjuuBankAndOffsetSelected
    ld [W_Battle_SelectedGraphicsBank], a
    pop af
    ld hl, Battle_DenjuuPortraitLookupTable
    ld d, 0
    ld e, a
    sla e
    rl d
    add hl, de
    ld a, [hli]
    ld h, [hl]
    ld l, a
    
    ld a, [W_Battle_SelectedPortraitBank]
    rst $10
    
    pop de
    ld a, c
    cp 1
    jp z, .loadReversedGraphic
    ld bc, M_Battle_DenjuuPortraitSize
    jp LCDC_LoadGraphicIntoVRAM

.loadReversedGraphic
    ld bc, M_Battle_DenjuuPortraitSize ;wastefully duplicated instr
    jp LCDC_LoadReversedGraphic
    
SECTION "Denjuu Portrait Loader Ptr Lookup Table", ROM0[$1731]
Battle_DenjuuPortraitLookupTable:
REPT M_Battle_DenjuuPortraitStride
    dw $4000 + (\@) * M_Battle_DenjuuPortraitSize
ENDR