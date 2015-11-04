# { DragDropContext, DragSource } = require 'react-dnd'
# backend = require 'react-dnd-touch-backend'
# context = DragDropContext backend

exports.Index = React.createClass
  mixins: [ Aui.Mixin ]
  componentDidMount: ->
    AlloyEditor.editable (@$ 'alloy')[0]
  render: ->
    document.title = 'Demo'
    <div ui segment>
      <div  ui green button>oi!</div>
      <div ref={ 'alloy' }>
        bam will this work?
      </div>
    </div>



# knightSource = {
#   beginDrag: (props) -> {}
# }
#
# collect = ( connect, monitor ) ->
#   connectDragSource: connect.dragSource()
#   isDragging: monitor.isDragging()


# Knight = (DragSource 'knight', knightSource, collect) React.createClass
#   render: ->
#     connectDragSource = @props.connectDragSource
#     isDragging = @props.isDragging
#     <p style={
#       fontSize: '3rem'
#       opacity: if isDragging then .5 else 1
#       cursor: 'move'
#     }>♘</p>
#
# Square = React.createClass
#   render: ->
#     black = @props.black
#     fill = if black then 'black' else 'white'
#     stroke = if black then 'white' else 'black'
#     <div style={ backgroundColor: fill, color: stroke, width: '100%', height: '100%' }>{ @props.children }</div>
#
# Board = context React.createClass
#   mixins: [ Bacon.Mixin ]
#   defaultProps: knightPosition: [0, 0]
#   getInitialState: ->
#     knightPosition: @props.knightPosition
#   componentWillMount: ->
#     @plug (
#       @eventStream 'moveKnight'
#         .filter @canMoveKnight
#     ), 'knightPosition'
#   canMoveKnight: (position) ->
#     dx = position[0] - @state.knightPosition[0]
#     dy = position[1] - @state.knightPosition[1]
#     ((Math.abs dx) is 2 and (Math.abs dy) is 1) or ((Math.abs dx) is 1 and (Math.abs dy) is 2)
#   renderSquare: (i) ->
#     x = i % 8
#     y = Math.floor (i / 8)
#     black = ( x + y ) % 2 is 1
#     piece = if ( x is @state.knightPosition[0] and y is @state.knightPosition[1] ) then <Knight /> else null
#     <div key={ i } style={ width: '12.5%', height: '12.5%' } onClick={ @moveKnight.bind @, [ x, y ] }>
#       <Square black={black}>{piece}</Square>
#     </div>
#   render: ->
#     squares =
#       @renderSquare index for index in [0..63]
#     <div style={ width: '100%', height: '100%', display: 'flex', flexWrap: 'wrap'}>
#       {squares}
#     </div>
