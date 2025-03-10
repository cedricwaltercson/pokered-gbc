PPRestore:

    ld hl, wPartySpecies
    ld de, wPartyMon1HP
.loadmon
    ld a, [hli]
    cp $ff
    jr z, .done

    push hl
    push de

    ld hl, wPartyMon1Status - wPartyMon1HP
    add hl, de
    xor a

    push de
    ld b, NUM_MOVES ; A Pokémon has 4 moves
.pp
    ld hl, wPartyMon1Moves - wPartyMon1HP
    add hl, de

    ld a, [hl]
    and a
    jr z, .nextmove

    dec a
    ld hl, wPartyMon1PP - wPartyMon1HP
    add hl, de

    push hl
    push de
    push bc

    ld hl, Moves
    ld bc, MOVE_LENGTH
    call AddNTimes
    ld de, wcd6d
    ld a, BANK(Moves)
    call FarCopyData
    ld a, [wcd6d + 5] ; PP is byte 5 of move data

    pop bc
    pop de
    pop hl

    inc de
    push bc
    ld b, a
    ld a, [hl]
    and $c0
    add b
    ld [hl], a
    pop bc

.nextmove
    dec b
    jr nz, .pp
    pop de

    pop de
    pop hl

    push hl
    ld bc, wPartyMon2 - wPartyMon1
    ld h, d
    ld l, e
    add hl, bc
    ld d, h
    ld e, l
    pop hl
    jr .loadmon

.done
    xor a
    ld [wWhichPokemon], a
    ld [wd11e], a

    ld a, [wPartyCount]
    ld b, a
.ppup
    push bc
    call RestoreBonusPP
    pop bc
    ld hl, wWhichPokemon
    inc [hl]
    dec b
    jr nz, .ppup
    ret
