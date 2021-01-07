
$("a.icon-pagination-next").click()

$(".icon-pdf-download").each(function(){
    const url = $(this).attr('href');
    window.open(url, '_blank');
    setTimeout(function(){}, 270);
});

$(".icon-pdf-download").each(function(){
    const url = $(this).attr('href');
    window.location.href = url;
    setTimeout(function(){}, 133);
});

$(".icon-pdf-download").each(function(){
    const url = $(this).attr('href');
    $(this).attr({
        target: '_blank',
        href:   url
    });
});

$('<iframe id="customdownloadframe"></iframe>').appendTo('#TOC')

$(".icon-pdf-download").each(
    function(){
        const url = $(this).attr('href');
        $(this).click(
            function(event){
                event.preventDefault();
                console.log("Opening " + url);
                $.get(url, function(data){
                        //window.location.href = $(this).attr('href')
                        //window.open(url, '_blank')
                        $('#customdownloadframe').src = url;
                    }
                )
            }
        )
        $(this).trigger("click")
    }
);


$(".icon-pdf-download").each(
    function(){
        const link_url = $(this).attr('href');
        $(this).click(
            function(event){
                event.preventDefault();
                console.log("Opening " + link_url);
                $.ajax( {
                    method: 'GET',
                    url: link_url,
                    dataType: 'pdf',
                    crossDomain: true,
                    success: (res) => {console.log(res)}
                }
                );
            }
        )
        $(this).trigger("click")
    }
);


DEFAULT_DELAY_MS = 1000
function downloadOnCurrentPage(class_name)
{
    let entry = 0;
    $(class_name).each(function(){
        const url = $(this).attr('href');
        window.open(url, '_blank');
        setTimeout(function(){}, DEFAULT_DELAY_MS);
        entry++;
    });
    return entry;
}


function downloadAllPages(class_name)
{
    let page = 0;
    let articles = 0;

    articles += downloadOnCurrentPage(class_name);
    console.log("Downloaded page " + page);

    while($("a.icon-pagination-next").length)
    {
        let next_button = $("a.icon-pagination-next");
        next_button.click().delay(DEFAULT_DELAY_MS);
        setTimeout(function(){}, DEFAULT_DELAY_MS);
        articles += downloadOnCurrentPage(class_name);
        page++;
        console.log("Downloaded page " + page);
    }
    return {"pages": page, "articles": articles};
}

result = downloadAllPages(".icon-pdf-download")
console.log(`Downloaded pages: ${result['pages']}`)
console.log(`Downloaded articles: ${result['articles']}`)
