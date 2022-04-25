import classes from "./ThirdPage.module.css"
import ScrollMenu from 'react-horizontal-scroll-menu';

const numberOfPicture = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

function clickNft(){
  console.log("aaaaaaaaaaa" )
}

function ThirdPage () {
  const child   = { width: '300em', height: '100%'}
  return (
    <div className={classes.scroll}>
    <ScrollMenu
    arrowLeft={<h2 className={classes.arrow}>{" <- "}</h2>} 
    arrowRight={<h2>{" <- "}</h2>}
    data={numberOfPicture.map((picture, index) => (

      <div className={classes.itemsContainer} key={index} onClick={clickNft}>
        <h2 className={classes.itemsTitle}>NFT</h2>
      
        <img
            style={{ height: "100px" }}
            alt="test"
            src="https://cdn.discordapp.com/attachments/960457923165818900/960999811853713468/unknown.png"
          />
        </div>
    ))}>

    </ScrollMenu>
    </div>
  );
};

export default ThirdPage;