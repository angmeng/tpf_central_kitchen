$(function () { 
	// Stack initialize
	var openspeed = 300;
	var closespeed = 300;
	$('.stack>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-50px', left: '10px'}, openspeed).addClass('openStack')
		   .find('li a>img').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-10px'}, closespeed);
		$el.next().find('li a>img').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '35px'});
	});
	
	// Stacks additional animation
	$('.stack li a').hover(function(){
		$("img",this).animate({width: '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("img",this).animate({width: '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
	
	
	$('.stack2>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-50px', left: '10px'}, openspeed).addClass('openStack')
		   .find('li a>img').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-10px'}, closespeed);
		$el.next().find('li a>img').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '35px'});
	});
	
	// Stacks additional animation
	$('.stack2 li a').hover(function(){
		$("img",this).animate({width: '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("img",this).animate({width: '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
	
	$('.stack3>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-50px', left: '10px'}, openspeed).addClass('openStack')
		   .find('li a>img').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-10px'}, closespeed);
		$el.next().find('li a>img').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '35px'});
	});
	
	// Stacks additional animation
	$('.stack3 li a').hover(function(){
		$("img",this).animate({width: '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("img",this).animate({width: '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
	
	
	$('.stack4>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-50px', left: '10px'}, openspeed).addClass('openStack')
		   .find('li a>img').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-10px'}, closespeed);
		$el.next().find('li a>img').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '35px'});
	});
	
	// Stacks additional animation
	$('.stack4 li a').hover(function(){
		$("img",this).animate({width: '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("img",this).animate({width: '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
	
	
	$('.stack5>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-50px', left: '10px'}, openspeed).addClass('openStack')
		   .find('li a>img').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-10px'}, closespeed);
		$el.next().find('li a>img').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '35px'});
	});
	
	// Stacks additional animation
	$('.stack5 li a').hover(function(){
		$("img",this).animate({width: '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("img",this).animate({width: '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
	
	
	$('.stack6>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-50px', left: '10px'}, openspeed).addClass('openStack')
		   .find('li a>img').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-10px'}, closespeed);
		$el.next().find('li a>img').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '35px'});
	});
	
	// Stacks additional animation
	$('.stack6 li a').hover(function(){
		$("img",this).animate({width: '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("img",this).animate({width: '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
	
	
	$('.stack7>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-50px', left: '10px'}, openspeed).addClass('openStack')
		   .find('li a>img').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-10px'}, closespeed);
		$el.next().find('li a>img').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '35px'});
	});
	
	// Stacks additional animation
	$('.stack7 li a').hover(function(){
		$("img",this).animate({width: '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("img",this).animate({width: '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
});


