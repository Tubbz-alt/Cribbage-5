import React from 'react'

const NewRoundTile = props => {
  let display = props.show ? '' : 'hide'
  return(
    <div className={`game_tile new_game ${display}`} onClick={props.handleClick}>
      Start a New Round
    </div>
  )
}

export default NewRoundTile
